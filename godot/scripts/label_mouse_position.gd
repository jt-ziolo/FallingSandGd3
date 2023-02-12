class_name LabelMousePosition
extends RichTextLabel

var _mouse_position: Vector2


func _process(_delta):
	var x = _mouse_position.x as int
	var y = _mouse_position.y as int
	self.bbcode_text = "({0}, {1})".format([x, y])


func _on_Brush_mouse_moved(mouse_position):
	_mouse_position = mouse_position
