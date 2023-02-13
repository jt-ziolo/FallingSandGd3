extends RichTextLabel

export(String, MULTILINE) var _template_text

var _mouse_position = [0, 0]

var format_dictionary = {
	"element_color": "pink",
	"element_name": "N/A",
	"brush_mode": "N/A",
}

func _process(_delta):
	if _mouse_position != null:
		self.bbcode_text = _template_text.format({"mouse_position": "{0}, {1}".format([_mouse_position[0], _mouse_position[1]])})
	self.bbcode_text = _template_text.format(format_dictionary)


func _on_Brush_mouse_moved(mouse_position):
	_mouse_position = mouse_position
