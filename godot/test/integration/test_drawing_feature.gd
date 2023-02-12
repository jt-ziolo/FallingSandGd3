extends GutTest


class TestFeatureDrawing:
	extends GutTest

	var _grid: Grid
	var _brush: Brush
	var _draw: Draw
	var _grain_type: GrainType

	func before_each():
		_grid = add_child_autofree(partial_double("res://scripts/grid.gd").new())
		stub(_grid, "is_valid_coord").to_return(true)
		_brush = add_child_autofree(partial_double("res://scripts/brush.gd").new())
		_draw = add_child_autofree(partial_double("res://scripts/draw.gd").new())
		_grid.connect("colors_transmitted", _draw, "_on_Grid_colors_transmitted")
		_grain_type = partial_double("res://scripts/grain_type.gd").new()
		_brush.grain_types = [_grain_type]
		assert_connected(_grid, _draw, "colors_transmitted", "_on_Grid_colors_transmitted")

	# Test to see that a signal will be sent by the grid script with the
	# parameter being a dictionary containing information for the draw script
	func test_grid_grains_drawn():
		watch_signals(_grid)

		# Manually emit first
		var signal_param = {[1, 10]: Color.red}
		_grid.emit_signal("colors_transmitted", signal_param)
		assert_signal_emitted_with_parameters(_grid, "colors_transmitted", [signal_param])

		# Feed in the coordinate/grain_type pair
		var coord = [100, 100]
		_grid._grains_by_coord[coord] = _grain_type
		assert_eq(_grid._grains_by_coord[coord], _grain_type)

		# Check to see if the script will emit by itself
		simulate(_grid, 1, 1)

		signal_param = {coord: Color.tan}
		assert_signal_emitted(_grid, "colors_transmitted")
		assert_signal_emitted_with_parameters(_grid, "colors_transmitted", [signal_param])

	func after_each():
		pass
