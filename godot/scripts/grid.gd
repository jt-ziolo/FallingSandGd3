class_name Grid
extends Node2D
# Holds all grains, gets player input and then applies interactions including
# movement to all grains before sending data for the draw update call to Draw

const HashSetPoint = preload("res://scripts/HashSetPoint.cs")
const HashSetInt = preload("res://scripts/HashSetInt.cs")
const HelperFunctions = preload("res://scripts/helper_functions.gd")
const Direction = preload("res://scripts/direction.gd")
const GrainType = preload("res://scripts/grain_type.gd")

signal colors_transmitted(colors)

export(Array, Resource) var interactions
export(bool) var has_floor = true

var _skip_set: HashSetPoint = HashSetPoint.new()

var _paint_points: Array = []
var _selected_type: GrainType

var _grains_by_point: Dictionary = {}

# 1000.0 milliseconds per second / times per second to yield seconds
#var _times_per_second: float = 800.0
#var _process_every: float = 1.0 / _times_per_second

#var _time_since_last_process: float = 10000.0  # must start high

var _grid_area_rect: Rect2
var _interaction_directions_by_grain_type = {}

func _ready():
	_grid_area_rect = get_viewport_rect()

func _process_brush_input():
	for point in _paint_points:
		var point_as_int_array = [point.x as int, point.y as int]
		if not _is_valid_point(point_as_int_array):
			continue
		_grains_by_point[point_as_int_array] = _selected_type
	_paint_points.clear()


func _is_valid_point(point):
	return _grid_area_rect.has_point(Vector2(point[0], point[1]))


func _get_interaction_directions(grain_type):
	if _interaction_directions_by_grain_type.has(grain_type):
		return _interaction_directions_by_grain_type[grain_type]
	var possible_directions = [
		Direction.UP,
		Direction.UP_RIGHT,
		Direction.RIGHT,
		Direction.DOWN_RIGHT,
		Direction.DOWN,
		Direction.DOWN_LEFT,
		Direction.LEFT,
		Direction.UP_LEFT,
	]
	var applicable_directions = HashSetInt.new()
	for interaction in interactions:
		if interaction.get_grain_type_self() != grain_type:
			continue
		for direction in possible_directions:
			if interaction.is_match_direction(direction):
				print("Adding direction {0} for interaction {1} of {2}".format([direction, interaction, grain_type]))
				applicable_directions.Add(direction)
	_interaction_directions_by_grain_type[grain_type] = applicable_directions.AsGodotArray()
	return _interaction_directions_by_grain_type[grain_type]


# Interactions include movement. Each interaction is an instruction for what to
# do when one grain meets another grain (or no grain) in some given direction.
func _process_interactions():
	var direction_offsets = {
		Direction.UP: [0, -1],
		Direction.UP_RIGHT: [1, -1],
		Direction.RIGHT: [1, 0],
		Direction.DOWN_RIGHT: [1, 1],
		Direction.DOWN: [0, 1],
		Direction.DOWN_LEFT: [-1, 1],
		Direction.LEFT: [-1, 0],
		Direction.UP_LEFT: [-1, -1],
	}

	_skip_set.Clear()

	# Will iterate through _grains_by_point and visit each boundary (direction)
	# between the current grain and its neighbor. If there is an interaction
	# and the neighbor has not been changed yet, then the interaction is
	# applied. If that interaction results in a change in the type of the
	# neighbor's grain, it is marked as changed. If it results in a change to
	# the type of the current grain, then no other interactions are evaluated
	# for the current grain this frame, otherwise interactions along other
	# directions are allowed to occur
	var new_grains_by_point: Dictionary = _grains_by_point.duplicate(true)
	for point_self in _grains_by_point.keys():
		if _skip_set.Contains(point_self[0], point_self[1]):
			continue
		var grain_type_self = _grains_by_point[point_self]
		if grain_type_self == null:
			continue
		var grain_type_other = null
		var force_directions_loop_break = false

		# Get only the directions that apply to this grain type
		var relevant_directions = _get_interaction_directions(grain_type_self)
		# We shuffle directions.keys to prevent biases in interactions that
		# would otherwise show up because of a fixed order
		var shuffled_directions = HelperFunctions.nonmut_shuffle(relevant_directions)

		for direction in shuffled_directions:
			if force_directions_loop_break:
				force_directions_loop_break = false
				break
			var offset = direction_offsets[direction]
			var point_other = [point_self[0] + offset[0], point_self[1] + offset[1]]
			if !_is_valid_point(point_other):
				continue
			if _skip_set.Contains(point_other[0], point_other[1]):
				continue
			grain_type_other = null
			if _grains_by_point.has(point_other):
				grain_type_other = _grains_by_point[point_other]
			if grain_type_self == grain_type_other:
				continue  # TODO: possibly add back in if we can optimize this

			var current_pair = [grain_type_self, grain_type_other]

			for interaction in interactions:
				var random_0_to_1 = rand_range(0, 1)
				if random_0_to_1 > interaction.get_likelihood(direction):
					continue
				var check_match = interaction.is_match_direction(direction)
				check_match = check_match and (current_pair[0] == interaction.get_grain_type_self())
				check_match = check_match and (current_pair[1] == interaction.get_grain_type_other())
				if not check_match:
					continue
				var output = interaction.get_interaction()
				if output[0] != grain_type_self:
					# The grain type in this square changed, so break out of
					# the directions loop, because we don't want to allow
					# multiple changes of one grain on the same frame
					force_directions_loop_break = true
				if output[1] != grain_type_other:
					# The grain type in the other square changed, so prevent it
					# from being changed again this frame
					_skip_set.Add(point_other[0], point_other[1])
				if output[0] != null:
					new_grains_by_point[point_self] = output[0]
				else:
					new_grains_by_point.erase(point_self)
				if output[1] != null:
					new_grains_by_point[point_other] = output[1]
				else:
					new_grains_by_point.erase(point_other)
	_grains_by_point = new_grains_by_point


# Send colors to be drawn
func _get_colors():
	var color_points = {}
	for point in _grains_by_point.keys():
		var grain_type: GrainType = _grains_by_point[point]
		color_points[point] = grain_type.color
	return color_points


func _process(delta):
	# _time_since_last_process += delta
	# if _time_since_last_process < _process_every:
	# return
	# _time_since_last_process = 0.0
	_process_brush_input()
	_process_interactions()
	var colors = _get_colors()
	emit_signal("colors_transmitted", colors)


func _on_Brush_painted(p_paint_points, selected_grain_type):
	_paint_points = p_paint_points
	_selected_type = selected_grain_type
