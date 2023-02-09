class_name InteractionBase
extends Resource

const Direction = preload("res://scripts/direction.gd")

var grain_type_self : Resource
var grain_type_other : Resource = null 
var direction = Direction.DOWN
var grain_type_new : Resource = null
var likelihood : float = 1.0

func is_match(input, p_direction, random_0_to_1):
	if random_0_to_1 > likelihood:
		return false
	var result = true
	result = result and (input[0] == grain_type_self)
	result = result and (input[1] == grain_type_other)
	result = result and (p_direction == direction)
	return result

func apply_interaction(input):
	return [input[0], input[1]]
