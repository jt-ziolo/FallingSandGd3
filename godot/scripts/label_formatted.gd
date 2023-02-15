class_name LabelFormatted
extends RichTextLabel

export(String, MULTILINE) var _template_text

var _mouse_position = [0, 0]
var _element_color = "gray"
var _element_name = "N/A"

var format_dictionary = {
	"element_color": "gray",
	"element_name": "None",
	"fps": 60,
	"grain_count": 0,
	"key_help": "H",
	"key_prev": "Q",
	"key_next": "E",
	"key_options": "RMB",
	"key_quit": "ESC",
}


func _process(_delta):
	if _mouse_position != null:
		self.bbcode_text = _template_text.format(
			{"mouse_position": "{0}, {1}".format([_mouse_position[0], _mouse_position[1]])}
		)
	format_dictionary["fps"] = Performance.get_monitor(Performance.TIME_FPS)
	if _element_name != "N/A":
		var color = "#{0}".format([_element_color.to_html(false)])
		format_dictionary["element_color"] = color
		format_dictionary["element_name"] = _element_name
	self.bbcode_text = self.bbcode_text.format(format_dictionary)
	self.bbcode_enabled = true


func _on_Brush_mouse_moved(mouse_position):
	_mouse_position = mouse_position


func _on_Brush_element_changed(selected_element):
	_element_color = selected_element.color
	_element_name = selected_element.human_friendly_name
