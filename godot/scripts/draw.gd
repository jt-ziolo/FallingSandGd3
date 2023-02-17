extends Node2D
class_name Draw

# const MAX_HISTORY_LENGTH = 1

# var _color_coords_history = []
# var _was_empty_last_frame = false
# var _do_clear = true
var _colors = {}


func _draw():
	for pos in _colors:
		var color = _colors[pos]
		draw_primitive([pos], [color], [Vector2.ONE])
	# if _do_clear:
	# draw_rect(get_viewport().get_visible_rect(), Color.black)
	# _do_clear = false
	# return
	# var counter = 1.0
	# for _color_coords in _color_coords_history:
	# for pos in _color_coords.keys():
	# var color = _color_coords[pos]
	# var factor = 1.0 / (MAX_HISTORY_LENGTH as float) * counter
	# color = color.lightened(1.0 - factor)
	# color.a = factor
	# draw_primitive([pos], [color], [Vector2.ONE])
	# counter += 1.0


func _on_Grid_colors_transmitted(colors: Dictionary):
	_colors = colors
	# if _color_coords_history.size() == 0:
	# if _was_empty_last_frame:
	# return
	# _was_empty_last_frame = true
	# else:
	# _was_empty_last_frame = false
	# if _color_coords_history.size() == MAX_HISTORY_LENGTH:
	# _color_coords_history.pop_front()
	# _color_coords_history.append(colors)
	update()
