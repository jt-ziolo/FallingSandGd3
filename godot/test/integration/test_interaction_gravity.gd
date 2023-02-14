extends GutTest

const HelperFunctions = preload("res://scripts/helper_functions.gd")

var _grid: Grid
var _element: Element
var _interaction: InteractionGravity
var _start_point = [10, 10]


func before_each():
	_element = Element.new()
	_interaction = InteractionGravity.new()
	_interaction.element_self = _element
	_interaction.element_other = null
	_grid = partial_double("res://scripts/grid.gd").new()
	stub(_grid, "_process_brush_input").to_do_nothing()
	stub(_grid, "_process_sliding").to_do_nothing()
	stub(_grid, "_get_colors").to_do_nothing()
	stub(_grid, "_is_valid_point").to_return(true)


func test_down_only():
	_grid._elements_by_point.clear()
	_grid._elements_by_point[_start_point] = _element
	_grid._interaction_directions_by_element.clear()
	_interaction.likelihood_down = 1.0
	_interaction.likelihood_down_to_side = 0.0
	_grid.interactions.clear()
	_grid.interactions.append(_interaction)

	assert_eq(_grid._elements_by_point[_start_point], _element)

	simulate(_grid, 10, 1)
	gut.p(_grid._elements_by_point)

	var keys = _grid._elements_by_point.keys()
	assert_eq(keys.size(), 1)
	var key = keys[0]
	assert_ne(key[1], _start_point[1])
	assert_gt(key[1], _start_point[1])
	assert_eq(key[0], _start_point[0])

	var value = _grid._elements_by_point.values()[0]
	assert_eq(value, _element)

func test_down_and_to_side():
	_grid._elements_by_point.clear()

	_grid._elements_by_point[_start_point] = _element
	_grid._interaction_directions_by_element.clear()
	_interaction.likelihood_down = 1.0
	_interaction.likelihood_down_to_side = 1.0
	_grid.interactions.clear()
	_grid.interactions.append(_interaction)

	assert_eq(_grid._elements_by_point[_start_point], _element)

	simulate(_grid, 30, 1)
	gut.p(_grid._elements_by_point)

	var keys = _grid._elements_by_point.keys()
	assert_eq(keys.size(), 1)
	var key = keys[0]
	assert_ne(key[1], _start_point[1])
	assert_gt(key[1], _start_point[1])
	assert_ne(key[0], _start_point[0])

	var value = _grid._elements_by_point.values()[0]
	assert_eq(value, _element)