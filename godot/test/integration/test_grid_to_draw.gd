extends GutTest

var _grid: Grid
var _brush: Brush
var _draw: Draw
var _element: Element


func before_each():
	_grid = partial_double("res://scripts/grid.gd").new()
	stub(_grid, "is_valid_point").to_return(true)
	_brush = partial_double("res://scripts/brush.gd").new()
	_draw = partial_double("res://scripts/draw.gd").new()
	_grid.connect("colors_transmitted", _draw, "_on_Grid_colors_transmitted")
	_element = Element.new()
	_element.color = Color.blue
	_brush.elements = [_element]
	assert_connected(_grid, _draw, "colors_transmitted", "_on_Grid_colors_transmitted")


# Test to see that a signal will be sent by the grid script with the
# parameter being a dictionary containing information for the draw script
func test_element_colors_transmitted():
	watch_signals(_grid)

	# Manually emit first
	var signal_param = {[1, 10]: Color.red}
	_grid.emit_signal("colors_transmitted", signal_param)
	assert_signal_emitted_with_parameters(_grid, "colors_transmitted", [signal_param])

	# Feed in the coordinate/element pair
	var point = [100, 100]
	_grid._elements_by_point[point] = _element
	assert_eq(_grid._elements_by_point[point], _element)

	# Check to see if the script will emit by itself
	# Simulate twice, accounting for grid.is_ready
	simulate(_grid, 5, 1)

	signal_param = {point: Color.blue}
	#assert_signal_emitted(_grid, "colors_transmitted")
	assert_signal_emitted_with_parameters(_grid, "colors_transmitted", [signal_param])
