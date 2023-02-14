class_name Grid
extends Node2D
# Holds all grains, gets player input and then applies interactions including
# movement to all grains before sending data for the draw update call to Draw

const HashSetPoint = preload("res://scripts/HashSetPoint.cs")
const HashSetInt = preload("res://scripts/HashSetInt.cs")
const HelperFunctions = preload("res://scripts/helper_functions.gd")
const Direction = preload("res://scripts/direction.gd")
const Element = preload("res://scripts/element.gd")

signal colors_transmitted(colors)

export(Array, Resource) var interactions
export(bool) var has_floor = true

var _skip_set: HashSetPoint = HashSetPoint.new()
var _paint_points: Array = []
var _selected_type: Element
var _elements_by_point: Dictionary = {}
var _grid_area_rect: Rect2
var _interaction_directions_by_element = {}


func _ready():
	_grid_area_rect = get_viewport_rect()


func _process_brush_input():
	for point in _paint_points:
		if not _is_valid_point(point):
			continue
		_elements_by_point[point] = _selected_type
	_paint_points.clear()


func _is_valid_point(point):
	return _grid_area_rect.has_point(Vector2(point[0], point[1]))


func _get_interaction_directions(element):
	if _interaction_directions_by_element.has(element):
		return _interaction_directions_by_element[element]
	var possible_directions = [
		Direction.NORTH,
		Direction.NORTH_EAST,
		Direction.EAST,
		Direction.SOUTH_EAST,
		Direction.SOUTH,
		Direction.SOUTH_WEST,
		Direction.WEST,
		Direction.NORTH_WEST,
	]
	var applicable_directions = HashSetInt.new()
	for interaction in interactions:
		if interaction.get_element_self() != element:
			continue
		for direction in possible_directions:
			if interaction.is_match_direction(direction):
				print(
					"Adding direction {0} for interaction {1} of {2}".format(
						[direction, interaction, element]
					)
				)
				applicable_directions.Add(direction)
	_interaction_directions_by_element[element] = applicable_directions.AsGodotArray()
	return _interaction_directions_by_element[element]


# For element types which slide, visit each point and if it is bordered on e.g.
# SOUTH/SOUTH_RIGHT/SOUTH_LEFT, move LEFT or RIGHT. Alternate between the two possible
# move directions depending on the current row. If neither are open, do
# nothing.
func _process_sliding():
	_skip_set.Clear()
	for point_self in _elements_by_point.keys():
		if _skip_set.Contains(point_self[0], point_self[1]):
			continue
		var element = _elements_by_point[point_self]
		if element.viscosity >= 1.0:
			continue
		var random_0_to_1 = rand_range(0, 1)
		if random_0_to_1 <= element.viscosity:
			continue
		# Determine slide direction (and continue if neither are open)
		#   Left
		var is_valid_left = false
		var point_other = [point_self[0] - 1, point_self[1]]
		if _is_valid_point(point_other):
			if not point_other in _elements_by_point:
				is_valid_left = true
		#	Right
		var is_valid_right = false
		point_other = [point_self[0] + 1, point_self[1]]
		if _is_valid_point(point_other):
			if not point_other in _elements_by_point:
				is_valid_right = true
		#	Decision
		if not (is_valid_left or is_valid_right):
			continue
		var point_slide = [0, 0]
		if is_valid_left:
			if is_valid_right:
				var slide_offset = -1
				# Choose based upon the row, alternating for even vs. odd rows
				var random_0_or_1 = randi() % 2
				if random_0_or_1 == 0:
					slide_offset = 1
				point_slide = [point_self[0] + slide_offset, point_self[1]]
			else:
				point_slide = [point_self[0] - 1, point_self[1]]
		else:
			point_slide = [point_self[0] + 1, point_self[1]]
		# Bottom
		var offsets = [[-1, 1], [0, 1], [1, 1]]
		var is_surrounded = true
		for offset in offsets:
			point_other = [point_self[0] + offset[0], point_self[1] + offset[1]]
			if !_is_valid_point(point_other):
				continue
			if not point_other in _elements_by_point:
				is_surrounded = false
		if is_surrounded:
			_elements_by_point[point_slide] = element
			_elements_by_point.erase(point_self)
			_skip_set.Add(point_slide[0], point_slide[1])


var direction_offsets = {
	Direction.NORTH: [0, -1],
	Direction.NORTH_EAST: [1, -1],
	Direction.EAST: [1, 0],
	Direction.SOUTH_EAST: [1, 1],
	Direction.SOUTH: [0, 1],
	Direction.SOUTH_WEST: [-1, 1],
	Direction.WEST: [-1, 0],
	Direction.NORTH_WEST: [-1, -1],
}


# Interactions include movement. Each interaction is an instruction for what to
# do when one element meets another element (or no element) in some given direction.
func _process_interactions():
	_skip_set.Clear()

	# Will iterate through _elements_by_point and visit each boundary
	# (direction) between the current element and its neighbor. If there is an
	# interaction and the neighbor has not been changed yet, then the
	# interaction is applied. If that interaction results in a change in the
	# neighbor's element, it is marked as changed. If it results in a change to
	# the type of the current element, then no other interactions are evaluated
	# for the current element this frame, otherwise interactions along other
	# directions are allowed to occur

	var new_elements_by_point: Dictionary = _elements_by_point.duplicate(true)
	for point_self in _elements_by_point.keys():
		if _skip_set.Contains(point_self[0], point_self[1]):
			continue
		var element_self = _elements_by_point[point_self]
		if element_self == null:
			continue
		var element_other = null
		var force_directions_loop_break = false

		# Get only the directions that apply to this element type
		var relevant_directions = _get_interaction_directions(element_self)

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
			element_other = null
			if _elements_by_point.has(point_other):
				element_other = _elements_by_point[point_other]
			if element_self == element_other:
				continue  # TODO: possibly add back in if we can optimize this

			var current_pair = [element_self, element_other]

			for interaction in interactions:
				var random_0_to_1 = rand_range(0, 1)
				if random_0_to_1 > interaction.get_likelihood(direction):
					continue
				var check_match = interaction.is_match_direction(direction)
				check_match = check_match and (current_pair[0] == interaction.get_element_self())
				check_match = check_match and (current_pair[1] == interaction.get_element_other())
				if not check_match:
					continue
				var output = interaction.get_interaction()
				if output[0] != element_self:
					# The element type in this square changed, so break out of
					# the directions loop, because we don't want to allow
					# multiple changes of one element on the same frame
					force_directions_loop_break = true
				if output[1] != element_other:
					# The element type in the other square changed, so prevent it
					# from being changed again this frame
					_skip_set.Add(point_other[0], point_other[1])
				if output[0] != null:
					new_elements_by_point[point_self] = output[0]
				else:
					new_elements_by_point.erase(point_self)
				if output[1] != null:
					new_elements_by_point[point_other] = output[1]
				else:
					new_elements_by_point.erase(point_other)
	_elements_by_point = new_elements_by_point


# Get colors to be drawn based on the elements in the grid
func _get_colors():
	var color_points = {}
	for point in _elements_by_point.keys():
		var element: Element = _elements_by_point[point]
		color_points[point] = element.color
	return color_points


func _process(delta):
	_process_brush_input()
	_process_sliding()
	_process_interactions()
	var colors = _get_colors()
	emit_signal("colors_transmitted", colors)


func _on_Brush_painted(p_paint_points, selected_element):
	_paint_points = p_paint_points
	_selected_type = selected_element
