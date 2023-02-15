extends GutTest

const HelperFunctions = preload("res://scripts/helper_functions.gd")

var _grid: Grid
var _element_a: Element
var _element_b: Element
var _interaction: Interaction
var _start_point = [10, 10]


func before_each():
	_element_a = Element.new()
	_element_a.human_friendly_name = "A"
	_element_b = Element.new()
	_element_b.human_friendly_name = "B"
	_interaction = Interaction.new()
	_interaction.directions = [Direction.SOUTH]
	_interaction.behavior = Interaction.Behavior.REPLACE_OTHER
	_interaction.element_new = _element_b
	_interaction.likelihood = 1.0
	_interaction.element_self = _element_a
	_interaction.element_other = null
	_grid = partial_double("res://scripts/grid.gd").new()
	stub(_grid, "_process_brush_input").to_do_nothing()
	stub(_grid, "_process_sliding").to_do_nothing()
	stub(_grid, "_process_lifetimes").to_do_nothing()
	stub(_grid, "_get_colors").to_do_nothing()
	stub(_grid, "_is_valid_point").to_return(true)


func test_replace_other():
	_interaction.behavior = Interaction.Behavior.REPLACE_OTHER
	for direction in range(8):
		_grid._elements_by_point.clear()
		_grid._elements_by_point[_start_point] = _element_a
		_grid._interaction_directions_by_element.clear()
		_grid.interactions.clear()
		_interaction.directions = [direction]
		_grid.interactions.append(_interaction)

		var offset = _grid.direction_offsets[direction]
		assert_eq(_grid._elements_by_point[_start_point], _element_a)
		var check_point = HelperFunctions.add_points(_start_point, offset)
		assert_false(_grid._elements_by_point.has(check_point))

		simulate(_grid, 1, 1)
		gut.p(_grid._elements_by_point)

		assert_true(_grid._elements_by_point.has(check_point))
		assert_eq(_grid._elements_by_point[check_point], _element_b)


func test_replace_self():
	_interaction.behavior = Interaction.Behavior.REPLACE_SELF
	for direction in range(8):
		_grid._elements_by_point.clear()
		_grid._elements_by_point[_start_point] = _element_a
		_grid._interaction_directions_by_element.clear()
		_grid.interactions.clear()
		_interaction.directions = [direction]
		_grid.interactions.append(_interaction)

		var offset = _grid.direction_offsets[direction]
		assert_eq(_grid._elements_by_point[_start_point], _element_a)
		var check_point = HelperFunctions.add_points(_start_point, offset)
		assert_false(_grid._elements_by_point.has(check_point))

		simulate(_grid, 1, 1)
		gut.p(_grid._elements_by_point)

		assert_true(_grid._elements_by_point.has(_start_point))
		assert_eq(_grid._elements_by_point[_start_point], _element_b)


func test_swap_no_new():
	_interaction.behavior = Interaction.Behavior.SWAP
	_interaction.element_new = null
	for direction in range(8):
		_grid._elements_by_point.clear()
		_grid._elements_by_point[_start_point] = _element_a
		_grid._interaction_directions_by_element.clear()
		_grid.interactions.clear()
		_interaction.directions = [direction]
		_grid.interactions.append(_interaction)

		var offset = _grid.direction_offsets[direction]
		assert_eq(_grid._elements_by_point[_start_point], _element_a)
		var check_point = HelperFunctions.add_points(_start_point, offset)
		assert_false(_grid._elements_by_point.has(check_point))

		simulate(_grid, 1, 1)
		gut.p(_grid._elements_by_point)

		assert_false(_grid._elements_by_point.has(_start_point))
		assert_true(_grid._elements_by_point.has(check_point))
		assert_eq(_grid._elements_by_point[check_point], _element_a)


func test_swap_with_new():
	_interaction.behavior = Interaction.Behavior.SWAP
	for direction in range(8):
		_grid._elements_by_point.clear()
		_grid._elements_by_point[_start_point] = _element_a
		_grid._interaction_directions_by_element.clear()
		_grid.interactions.clear()
		_interaction.directions = [direction]
		_grid.interactions.append(_interaction)

		var offset = _grid.direction_offsets[direction]
		assert_eq(_grid._elements_by_point[_start_point], _element_a)
		var check_point = HelperFunctions.add_points(_start_point, offset)
		assert_false(_grid._elements_by_point.has(check_point))

		simulate(_grid, 1, 1)
		gut.p(_grid._elements_by_point)

		assert_false(_grid._elements_by_point.has(_start_point))
		assert_true(_grid._elements_by_point.has(check_point))
		assert_eq(_grid._elements_by_point[check_point], _element_b)


func test_replace_both():
	_interaction.behavior = Interaction.Behavior.REPLACE_BOTH
	for direction in range(8):
		_grid._elements_by_point.clear()
		_grid._elements_by_point[_start_point] = _element_a
		_grid._interaction_directions_by_element.clear()
		_grid.interactions.clear()
		_interaction.directions = [direction]
		_grid.interactions.append(_interaction)

		var offset = _grid.direction_offsets[direction]
		assert_eq(_grid._elements_by_point[_start_point], _element_a)
		var check_point = HelperFunctions.add_points(_start_point, offset)
		assert_false(_grid._elements_by_point.has(check_point))

		simulate(_grid, 1, 1)
		gut.p(_grid._elements_by_point)

		assert_eq(_grid._elements_by_point[_start_point], _element_b)
		assert_eq(_grid._elements_by_point[check_point], _element_b)
