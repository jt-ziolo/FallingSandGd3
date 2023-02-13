class_name GrainType
extends Resource
# Holds data related to a grain's type, to be used when drawing

export var human_friendly_name:String = "Example Name"
export var color:Color = Color.tan
func _to_string():
	return human_friendly_name
