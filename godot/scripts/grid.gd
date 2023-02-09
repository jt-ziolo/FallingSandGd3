class_name Grid
extends Node
# Holds all grains, gets player input and then applies interactions including
# movement to all grains before sending data for the draw update call to Draw

const HelperFunctions = preload("res://scripts/helper_functions.gd")
const Direction = preload("res://scripts/direction.gd")
const GrainType = preload("res://scripts/grain_type.gd")

signal transmit_colors(colors)

# Three interaction arrays, needed to allow for prioritization. The elements
# within each array get shuffled during the processing step, but the arrays are
# processed in the order of _first, normal then _last
export(Array, Resource) var interactions_first
export(Array, Resource) var interactions
export(Array, Resource) var interactions_last

var _paint_coords: Array = []
var _selected_type: GrainType

var _grains_by_coord: Dictionary = {}

# 1000.0 milliseconds per second / times per second to yield seconds
var _times_per_second: float = 800.0
var _process_every: float = 1.0 / _times_per_second

var _time_since_last_process: float = 10000.0  # must start high


func process_brush_input():
	for coord in _paint_coords:
		if not is_valid_coord(coord):
			continue
		_grains_by_coord[coord] = _selected_type


func is_valid_coord(coord):
	var viewport_rect = get_viewport().get_visible_rect()
	if typeof(coord) != TYPE_VECTOR2:
		var vec2 = Vector2(coord[0], coord[1])
		return viewport_rect.has_point(vec2)
	return viewport_rect.has_point(coord)


# Interactions include movement. Each interaction is an instruction for what to
# do when one grain meets another grain (or no grain) in some given direction.
func _apply_interactions():
	var skip_because_changed = []

	var directions = {
		[0, -1]: Direction.UP,
		[1, -1]: Direction.UP_RIGHT,
		[1, 0]: Direction.RIGHT,
		[1, 1]: Direction.DOWN_RIGHT,
		[0, 1]: Direction.DOWN,
		[-1, 1]: Direction.DOWN_LEFT,
		[-1, 0]: Direction.LEFT,
		[-1, -1]: Direction.UP_LEFT,
	}

	# Will iterate through _grains_by_coord and visit each boundary (direction)
	# between the current grain and its neighbor. If there is an interaction
	# and the neighbor has not been changed yet, then the interaction is
	# applied. If that interaction results in a change in the type of the
	# neighbor's grain, it is marked as changed. If it results in a change to
	# the type of the current grain, then no other interactions are evaluated
	# for the current grain this frame, otherwise interactions along other
	# directions are allowed to occur
	var new_grains_by_coord = _grains_by_coord.duplicate(true)  # deep copy TODO: is it necessary?
	var interaction_arrays = [interactions_first, interactions, interactions_last]
	for coord_self in _grains_by_coord.keys():
		var grain_type_self = _grains_by_coord[coord_self]
		if skip_because_changed.has(coord_self):
			continue
		var grain_type_other = null
		var force_directions_loop_break = false

		# We shuffle directions.keys to prevent biases in interactions that
		# would otherwise show up because of a fixed order
		var shuffled_directions = HelperFunctions.nonmut_shuffle(directions.keys())

		for j in shuffled_directions:
			if force_directions_loop_break:
				force_directions_loop_break = false
				break
			var coord_other = [coord_self[0] + j[0], coord_self[1] + j[1]]
			if !is_valid_coord(coord_other):
				continue
			if skip_because_changed.has(coord_other):
				continue
			grain_type_other = null
			if _grains_by_coord.has(coord_other):
				grain_type_other = _grains_by_coord[coord_other]
			if grain_type_self == grain_type_other:
				continue  # TODO: possibly add back in if we can optimize this
			var direction = directions[j]
			# Apply interactions
			var input = [grain_type_self, grain_type_other]

			for interaction_array in interaction_arrays:
				# Shuffling interactions too. Priority will be taken care of by
				# having three arrays
				var shuffled_interaction_array = HelperFunctions.nonmut_shuffle(interaction_array)

				for k in shuffled_interaction_array:
					var random_0_to_1 = rand_range(0, 1)
					if random_0_to_1 > k.get_likelihood(direction):
						continue
					var check_match = k.is_match_direction(direction)
					check_match = check_match and (input[0] == k.get_grain_type_self())
					check_match = check_match and (input[1] == k.get_grain_type_other())
					if not check_match:
						continue
					var output = k.apply_interaction(input)
					if output[0] != grain_type_self:
						# The grain type in this square changed, so break out of
						# the directions loop, see below for more details on why
						force_directions_loop_break = true
					if output[1] != grain_type_other:
						# The grain type in the other square changed, so prevent it
						# from being changed again this frame... otherwise there
						# will be many bugs (the input _grains_by_coord dict does not
						# change in this loop, as one example)
						skip_because_changed.append(coord_other)
					if output[0] == null:
						new_grains_by_coord.erase(coord_self)
					else:
						new_grains_by_coord[coord_self] = output[0]
					if output[1] == null:
						new_grains_by_coord.erase(coord_other)
					else:
						new_grains_by_coord[coord_other] = output[1]
	_grains_by_coord = new_grains_by_coord


# Send colors to be drawn
func _get_colors():
	var color_coords = {}
	for coord in _grains_by_coord.keys():
		var grain_type: GrainType = _grains_by_coord[coord]
		color_coords[coord] = grain_type.color
	return color_coords


func _process(delta):
	_time_since_last_process += delta
	if _time_since_last_process < _process_every:
		return
	_time_since_last_process = 0.0
	process_brush_input()
	_apply_interactions()
	var colors = _get_colors()
	emit_signal("transmit_colors", colors)


func _on_Brush_painted(p_paint_coords, selected_grain_type):
	_paint_coords = p_paint_coords
	_selected_type = selected_grain_type
