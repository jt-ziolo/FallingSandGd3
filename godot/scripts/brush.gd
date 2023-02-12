extends Node
class_name Brush

signal painted(paint_coords, selected_grain_type)

export(Resource) var selected_grain_type


# The paint action is set up in the Godot project settings
func _process(_delta):
	if not Input.is_action_pressed("paint"):
		return
	var mouse_position = get_viewport().get_mouse_position()
	emit_signal("painted", [mouse_position], selected_grain_type)
