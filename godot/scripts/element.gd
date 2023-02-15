class_name Element
extends Resource
# Holds data related to a grain's type, to be used when drawing

export var human_friendly_name: String = "Example Name"
export var color: Color = Color.tan
export var is_brush_paintable: bool = true
export(float, 0.0, 1.0) var viscosity = 1.0
export var lifetime_frames: int = -1
export var lifetime_replaced_by: Resource


func _to_string():
	return human_friendly_name
