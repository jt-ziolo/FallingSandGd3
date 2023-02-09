class_name GradientColorRect
extends ColorRect

var _background_color: Color = Color.darkgray
const _width: float = 50.0


func _process(_delta):
	update()


func _draw():
	var size = get_viewport().get_visible_rect().size
	var location: float = 0.0
	var alpha: float = 0.05
	while location < size[1]:
		location += _width
		var from = Vector2(0, location)
		var to = Vector2(size[0], location)
		draw_line(
			from,
			to,
			Color(_background_color.r, _background_color.g, _background_color.b, alpha),
			_width,
			false
		)
		alpha *= 1.2
