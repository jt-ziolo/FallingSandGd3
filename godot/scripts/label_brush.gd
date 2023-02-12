extends RichTextLabel

export(String, MULTILINE) var _template_text

var format_dictionary = {
	"grain_color": "pink",
	"grain_type": "N/A",
	"brush_size": "N/A",
	"brush_mode": "N/A",
}

func _process(_delta):
	self.bbcode_text = _template_text.format(format_dictionary)
