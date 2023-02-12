extends Node2D
class_name Brush

signal painted(paint_coordinates, selected_grain_type)
signal mouse_moved(_mouse_position)

export(Resource) var selected_grain_type

var _mouse_position: Vector2
var _last_mouse_position: Vector2


# The paint action is set up in the Godot project settings
func _process(_delta):
	if _mouse_position != _last_mouse_position:
		emit_signal("mouse_moved", _mouse_position)
		_last_mouse_position = _mouse_position
	if not Input.is_action_pressed("paint"):
		return
	emit_signal("painted", [_mouse_position], selected_grain_type)


func _unhandled_input(event):
	if not (event is InputEventMouseMotion):
		return
	var use_event = make_input_local(event) as InputEventMouseMotion
	_mouse_position = use_event.position
	get_tree().set_input_as_handled()
