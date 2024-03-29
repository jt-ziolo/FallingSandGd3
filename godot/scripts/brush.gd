extends Node2D
class_name Brush

signal painted(paint_coordinates, selected_element)
signal mouse_moved(_mouse_position)
signal element_changed(selected_element)

const IteratorCircularArray = preload("res://scripts/IteratorCircularArray.cs")

export(Resource) var selected_element
var elements: Array

var _elements_iterator: IteratorCircularArray
var _mouse_position: Vector2
var _last_mouse_position_int = [0 as int, 0 as int]

const BRUSH_SIZE: int = 4
const MOUSE_INTERPOLATION_FACTOR: float = 0.3


func _init():
	_load_elements()
	# Properly add the C# node to the tree so it does not become an orphan
	_elements_iterator = IteratorCircularArray.new()
	add_child(_elements_iterator)


func _ready():
	_elements_iterator.StartForArray(elements)
	emit_signal("element_changed", selected_element)


func _load_elements():
	# Use Godot.load on all files in the res://elements directory
	var element_paths = []
	var dir = Directory.new()
	if dir.open("res://elements") == OK:
		dir.list_dir_begin()
		var next = dir.get_next()
		while next != "":
			if dir.current_is_dir():
				next = dir.get_next()
				continue
			element_paths.append(next)
			next = dir.get_next()
	dir.list_dir_end()
	print(element_paths)
	# Load elements into the elements array
	for path in element_paths:
		var next_element: Element = load("res://elements/{0}".format([path]))
		if next_element.is_brush_paintable:
			elements.append(next_element)


# The paint action is set up in the Godot project settings
func _physics_process(_delta):
	var _mouse_position_int = [_mouse_position.x as int, _mouse_position.y as int]
	_mouse_position_int = [_mouse_position_int[0] - BRUSH_SIZE, _mouse_position_int[1] - BRUSH_SIZE]
	if _mouse_position_int != _last_mouse_position_int:
		_mouse_position_int = HelperFunctions.interpolate_between_points(_last_mouse_position_int, _mouse_position_int, MOUSE_INTERPOLATION_FACTOR)
		emit_signal("mouse_moved", _mouse_position_int)
		_last_mouse_position_int = _mouse_position_int
	if Input.is_action_just_released("element_next"):
		_scroll_element(true)
	if Input.is_action_just_released("element_previous"):
		_scroll_element(false)
	if not Input.is_action_pressed("paint"):
		return
	emit_signal("painted", _get_painted_points(_mouse_position_int), selected_element)


func _get_painted_points(mouse_position_int):
	var painted_points = []
	for i in range(BRUSH_SIZE):
		for j in range(BRUSH_SIZE):
			painted_points.append([mouse_position_int[0] + i, mouse_position_int[1] + j])
	return painted_points


func _scroll_element(do_go_forward):
	var index: int
	if do_go_forward:
		index = _elements_iterator.GoForwardOnce()
	else:
		index = _elements_iterator.GoBackwardOnce()
	var last_element = selected_element
	selected_element = elements[index]
	if selected_element != last_element:
		emit_signal("element_changed", selected_element)


func _unhandled_input(event):
	if not (event is InputEventMouseMotion):
		return
	var use_event = make_input_local(event) as InputEventMouseMotion
	_mouse_position = use_event.position
	get_tree().set_input_as_handled()
