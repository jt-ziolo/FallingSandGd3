extends Node2D
class_name Draw

var _color_coords = {}


func _draw():
	# Draw the forward layer
	for pos in _color_coords.keys():
		var pos_vec2 = Vector2(pos[0], pos[1])
		draw_rect(Rect2(pos_vec2, Vector2(1, 1)), _color_coords[pos], true, 1.0, false)


func _on_Grid_transmit_colors(colors):
	_color_coords = colors
	update()
