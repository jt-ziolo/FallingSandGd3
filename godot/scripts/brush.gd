extends Node2D
class_name Brush

signal painted(paint_coordinates, selected_grain_type)
signal mouse_moved(_mouse_position)

const CircularArrayBacker = preload("res://scripts/CircularArrayBacker.cs")

export(Resource) var selected_grain_type
export(Array, Resource) var grain_types

var _grain_types_backer: CircularArrayBacker = CircularArrayBacker.new()
var _mouse_position: Vector2
var _last_mouse_position: Vector2


func _ready():
	_grain_types_backer.StartForArray(grain_types)


# The paint action is set up in the Godot project settings
func _process(_delta):
	if _mouse_position != _last_mouse_position:
		emit_signal("mouse_moved", _mouse_position)
		_last_mouse_position = _mouse_position
	if Input.is_action_just_released("grain_type_next"):
		_scroll_grain_type(true)
	if Input.is_action_just_released("grain_type_previous"):
		_scroll_grain_type(false)
	if not Input.is_action_pressed("paint"):
		return
	emit_signal("painted", [_mouse_position], selected_grain_type)


func _scroll_grain_type(do_go_forward):
	var index: int
	if do_go_forward:
		index = _grain_types_backer.GoForwardOnce()
	else:
		index = _grain_types_backer.GoBackwardOnce()
	selected_grain_type = grain_types[index]


func _unhandled_input(event):
	if not (event is InputEventMouseMotion):
		return
	var use_event = make_input_local(event) as InputEventMouseMotion
	_mouse_position = use_event.position
	get_tree().set_input_as_handled()
