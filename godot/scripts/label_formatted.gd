class_name LabelFormatted
extends RichTextLabel

export(String, MULTILINE) var _template_text

var _mouse_position = [0, 0]
var _element_color = "gray"
var _element_name = "N/A"
var _grain_count = 0

# Key bindings must be manually added here, because it is fairly complicated to
# get the key bindings of the InputMap through code (without setting up an
# in-game custom keybind menu which is out of scope for now)
var _format_dictionary = {
	"element_color": "gray",
	"element_name": "N/A",
	"fps": 60,
	"grain_count": 0,
	"key_prev": "Q",
	"key_next": "E",
	"key_pause": "ESC",
}


func _process(_delta):
	if _mouse_position != null:
		self.bbcode_text = _template_text.format(
			{"mouse_position": "{0}, {1}".format([_mouse_position[0], _mouse_position[1]])}
		)
	_format_dictionary["fps"] = Performance.get_monitor(Performance.TIME_FPS)
	if _element_name != "N/A":
		var color = "#{0}".format([_element_color.to_html(false)])
		_format_dictionary["element_color"] = color
		_format_dictionary["element_name"] = _element_name
	_format_dictionary["grain_count"] = _grain_count
	self.bbcode_text = self.bbcode_text.format(_format_dictionary)
	self.bbcode_enabled = true


func _on_Brush_mouse_moved(mouse_position):
	_mouse_position = mouse_position


func _on_Brush_element_changed(selected_element):
	_element_color = selected_element.color
	_element_name = selected_element.human_friendly_name

func _on_Grid_grain_count_changed(count):
	_grain_count = count
