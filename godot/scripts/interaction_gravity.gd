class_name InteractionGravity
extends InteractionBase
# Simulates one grain falling into another (or empty space). The likelihood of
# the grain "spreading out" (falling in the down/left and down/right
# directions) is controlled by a separate likelihood variable than just falling
# straight down.

export(float, 0, 1) var likelihood_down = 1.0
export(float, 0, 1) var likelihood_down_to_side = 0.05
export(Resource) var grain_type_self = null
export(Resource) var grain_type_other = null


func get_grain_type_self():
	return grain_type_self


func get_grain_type_other():
	return grain_type_other


func get_likelihood(p_direction):
	match p_direction:
		Direction.DOWN:
			return likelihood_down
		Direction.DOWN_LEFT:
			return likelihood_down_to_side
		Direction.DOWN_RIGHT:
			return likelihood_down_to_side
		_:
			return 0.0


func is_match_direction(p_direction):
	match p_direction:
		Direction.DOWN:
			return true
		Direction.DOWN_LEFT:
			return true
		Direction.DOWN_RIGHT:
			return true
		_:
			return false


func apply_interaction(input):
	return [input[1], input[0]]
