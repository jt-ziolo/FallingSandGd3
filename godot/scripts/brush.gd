extends Node2D
class_name Brush

signal painted(paint_coordinates, selected_grain_type)
signal mouse_moved(_mouse_position)

const CircularArrayBacker = preload("res://scripts/CircularArrayBacker.cs")

export(Resource) var selected_grain_type
export(Array, Resource) var grain_types

var _grain_types_backer: CircularArrayBacker = CircularArrayBacker.new()
var _mouse_position: Vector2
var _last_mouse_position_int = [0 as int, 0 as int]

const BRUSH_SIZE: int = 4

func _ready():
	_grain_types_backer.StartForArray(grain_types)


# The paint action is set up in the Godot project settings
func _process(_delta):
	var _mouse_position_int = [_mouse_position.x as int, _mouse_position.y as int]
	_mouse_position_int = [_mouse_position_int[0] - BRUSH_SIZE, _mouse_position_int[1] - BRUSH_SIZE]
	if _mouse_position_int != _last_mouse_position_int:
		emit_signal("mouse_moved", _mouse_position_int)
		_last_mouse_position_int = _mouse_position_int
	if Input.is_action_just_released("grain_type_next"):
		_scroll_grain_type(true)
	if Input.is_action_just_released("grain_type_previous"):
		_scroll_grain_type(false)
	if not Input.is_action_pressed("paint"):
		return
	emit_signal("painted", _get_painted_points(_mouse_position_int), selected_grain_type)


func _get_painted_points(mouse_position_int):
	var painted_points = []
	for i in range(BRUSH_SIZE):
		for j in range(BRUSH_SIZE):
			painted_points.append([mouse_position_int[0] + i, mouse_position_int[1] + j])
	return painted_points


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
