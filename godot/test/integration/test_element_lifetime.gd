extends GutTest

var _grid: Grid
var _element_a: Element
var _element_b: Element


func before_each():
	_element_a = Element.new()
	_element_a.human_friendly_name = "A"
	_element_a.lifetime_frames = -1
	_element_a.lifetime_replaced_by = null
	_element_b = Element.new()
	_element_b.lifetime_frames = 5
	_element_b.lifetime_replaced_by = _element_a
	_element_b.human_friendly_name = "B"
	_grid = partial_double("res://scripts/grid.gd").new()
	stub(_grid, "_process_brush_input").to_do_nothing()
	stub(_grid, "_process_sliding").to_do_nothing()
	stub(_grid, "_process_interactions").to_do_nothing()
	stub(_grid, "_get_colors").to_do_nothing()
	stub(_grid, "_is_valid_point").to_return(true)


func test_infinite_lifetime():
	_grid._elements_by_point.clear()
	_grid._elements_by_point[[0, 0]] = _element_a

	assert_eq(_grid._elements_by_point[[0, 0]], _element_a)

	simulate(_grid, 25, 1)
	gut.p(_grid._elements_by_point)

	assert_true(_grid._elements_by_point.has([0, 0]))
	assert_eq(_grid._elements_by_point[[0, 0]], _element_a)


func test_lifetime_replace_to_element():
	_grid._elements_by_point.clear()
	_grid._elements_by_point[[0, 0]] = _element_b

	assert_eq(_grid._elements_by_point[[0, 0]], _element_b)

	simulate(_grid, 25, 1)
	gut.p(_grid._elements_by_point)

	assert_true(_grid._elements_by_point.has([0, 0]))
	assert_eq(_grid._elements_by_point[[0, 0]], _element_a)


func test_lifetime_not_enough_frames():
	_grid._elements_by_point.clear()
	_grid._elements_by_point[[0, 0]] = _element_b

	assert_eq(_grid._elements_by_point[[0, 0]], _element_b)

	simulate(_grid, 3, 1)
	gut.p(_grid._elements_by_point)

	assert_true(_grid._elements_by_point.has([0, 0]))
	assert_eq(_grid._elements_by_point[[0, 0]], _element_b)


func test_lifetime_replace_as_null():
	_element_a.lifetime_frames = 2
	_grid._elements_by_point.clear()
	_grid._elements_by_point[[0, 0]] = _element_a

	assert_eq(_grid._elements_by_point[[0, 0]], _element_a)

	simulate(_grid, 25, 1)
	gut.p(_grid._elements_by_point)

	assert_false(_grid._elements_by_point.has([0, 0]))
