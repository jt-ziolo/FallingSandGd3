class_name ColorRectGradient
extends ColorRect

var _background_color: Color = Color.darkgray
var A_FINAL: float = 0.4
var A_INITIAL: float = 0.05
const N_BANDS: int = 50


func _ready():
	update()


func _draw():
	var size = get_viewport().get_visible_rect().size

	# start with a negative offset since the first iteration of the loop will
	# add _width again, and we want to start at position 0
	var width: float = size[1] / N_BANDS
	var location: float = -1 * width

	var initial_alpha: float = A_INITIAL
	var alpha: float = initial_alpha
	var counter = 0
	while location < size[1]:
		location += width
		var from = Vector2(0, location)
		var to = Vector2(size[0], location)
		draw_line(
			from,
			to,
			Color(_background_color.r, _background_color.g, _background_color.b, alpha),
			width,
			false
		)
		counter += 1
		alpha = (A_FINAL - A_INITIAL) / N_BANDS * counter + A_INITIAL
