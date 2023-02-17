extends Node2D
class_name Draw

var _do_clear = true
var _colors = {}


func _draw():
	for pos in _colors:
		var color = _colors[pos]

		# Some simple color manipulations to make things look more interesting
		# TODO: Make recoloring a feature of the element, or use a shader pass
		# to accomplish this

		# Fire/Lava
		if color.r > 0.7:
			color = color.lightened(rand_range(0, 0.3))
		# Water
		if color.b > 0.7:
			var rand = rand_range(0, 0.5)
			color = color.lightened(rand*rand)

		draw_primitive([pos], [color], [Vector2.ONE])
	if _do_clear:
		var viewport = get_viewport()
		viewport.render_target_clear_mode = viewport.CLEAR_MODE_ONLY_NEXT_FRAME
		_do_clear = false


func _on_Grid_colors_transmitted(colors: Dictionary):
	_colors = colors
	update()

func _on_Grid_colors_clear():
	_do_clear = true
	var viewport = get_viewport()
	viewport.render_target_clear_mode = viewport.CLEAR_MODE_ALWAYS
	update()
