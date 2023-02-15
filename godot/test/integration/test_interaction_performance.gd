extends GutTest

const HelperFunctions = preload("res://scripts/helper_functions.gd")

var _grid: Grid
var _element_a: Element
var _element_b: Element
var _interaction_a: InteractionGravity
var _interaction_b: Interaction
var _start_point = [10, 10]


func before_each():
	_element_a = Element.new()
	_element_a.human_friendly_name = "A"
	_element_b = Element.new()
	_element_b.human_friendly_name = "B"

	_interaction_a = InteractionGravity.new()
	_interaction_a.likelihood_down = 1.0
	_interaction_a.likelihood_down_to_side = 1.0
	_interaction_a.element_self = _element_a
	_interaction_a.element_other = null

	# Element B is a spout for Element A
	_interaction_b = Interaction.new()
	# All directions
	_interaction_b.directions = range(8)
	_interaction_b.behavior = Interaction.Behavior.REPLACE_OTHER
	_interaction_b.element_new = _element_a
	_interaction_b.likelihood = 1.0
	_interaction_b.element_self = _element_b
	_interaction_b.element_other = null

	_grid = partial_double("res://scripts/grid.gd").new()
	stub(_grid, "_process_brush_input").to_do_nothing()
	stub(_grid, "_process_sliding").to_do_nothing()
	stub(_grid, "_process_lifetimes").to_do_nothing()
	stub(_grid, "_get_colors").to_do_nothing()
	stub(_grid, "_is_valid_point").to_return(true)


func test_interaction_performance():
	_grid._elements_by_point.clear()
	_grid._elements_by_point[_start_point] = _element_b
	_grid._interaction_directions_by_element.clear()
	_grid.interactions.clear()
	_grid.interactions.append(_interaction_a)
	_grid.interactions.append(_interaction_b)

	assert_eq(_grid._elements_by_point[_start_point], _element_b)

	var time_start = Time.get_ticks_usec()
	for i in range(50):
		simulate(_grid, 1, 1)
	var time_end = Time.get_ticks_usec()
	var time_difference = time_end - time_start
	gut.p(
		"#### Manually check performance. For 50 calls, took {0} microseconds, {1} average".format(
			[time_difference, time_difference / 50.0]
		)
	)
	gut.p(_grid._elements_by_point.keys().size())
