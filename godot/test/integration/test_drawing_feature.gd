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
		_grid.connect("transmit_colors", _draw, "_on_Grid_transmit_colors")
		_grain_type = partial_double("res://scripts/grain_type.gd").new()
		assert_connected(_grid, _draw, "transmit_colors", "_on_Grid_transmit_colors")

	# Test to see that a signal will be sent by the grid script with the
	# parameter being a dictionary containing information for the draw script
	func test_grid_grains_drawn():
		_grid._grains_by_coord[[100, 100]] = _grain_type
		assert_eq(_grid._grains_by_coord[[100, 100]], _grain_type)
		watch_signals(_grid)

		# Manually emit first
		var signal_param = {[1, 10]: Color.red}
		_grid.emit_signal("transmit_colors", signal_param)
		assert_signal_emitted_with_parameters(_grid, "transmit_colors", [signal_param])

		# Check to see if the script will emit by itself
		# this approach must be used for doubles
		yield(yield_for(1), YIELD)

		assert_eq(_grid._grains_by_coord[[100, 100]], _grain_type)
		signal_param = {[100, 100]: Color.tan}
		assert_signal_emitted(_grid, "transmit_colors")
		assert_signal_emitted_with_parameters(_grid, "transmit_colors", [signal_param])

	func after_each():
		pass
