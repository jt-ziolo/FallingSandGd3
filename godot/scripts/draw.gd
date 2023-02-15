extends Node2D
class_name Draw

var _color_coords = {}
var _was_empty_last_frame = false


func _draw():
	# Draw the forward layer
	for pos in _color_coords.keys():
		var pos_vec2 = Vector2(pos[0], pos[1])
		draw_rect(Rect2(pos_vec2, Vector2(1, 1)), _color_coords[pos], true, 1.0, false)


func _on_Grid_colors_transmitted(colors: Dictionary):
	if colors.empty():
		if _was_empty_last_frame:
			return
		_was_empty_last_frame = true
	else:
		_was_empty_last_frame = false
	_color_coords = colors
	update()
