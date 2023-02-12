extends Node
class_name Brush

signal painted(paint_coordinates, selected_grain_type)
signal mouse_moved(mouse_position)

export(Resource) var selected_grain_type

var _last_mouse_position: Vector2

# The paint action is set up in the Godot project settings
func _process(_delta):
	var mouse_position = get_viewport().get_mouse_position()
	if mouse_position != _last_mouse_position:
		emit_signal("mouse_moved", mouse_position)
		_last_mouse_position = mouse_position
	if not Input.is_action_pressed("paint"):
		return
	emit_signal("painted", [mouse_position], selected_grain_type)
