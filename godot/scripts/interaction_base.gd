class_name InteractionBase
extends Resource

const Direction = preload("res://scripts/direction.gd")


func get_grain_type_other() -> Resource:
	return null


func get_grain_type_self() -> Resource:
	return null


func get_likelihood(p_direction) -> float:
	return 1.0


func is_match_direction(p_direction) -> bool:
	return false


func get_interaction():
	return [null, null]
