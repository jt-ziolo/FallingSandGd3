class_name InteractionGravity
extends InteractionBase
# Simulates one grain falling into another (or empty space). The likelihood of
# the grain "spreading out" (falling in the down/left and down/right
# directions) is controlled by a separate likelihood variable than just falling
# straight down.

export(float, 0, 1) var likelihood_down = 1.0
export(float, 0, 1) var likelihood_down_to_side = 0.05
export(Resource) var element_self = null
export(Resource) var element_other = null


func get_element_self():
	return element_self


func get_element_other():
	return element_other


func get_likelihood(p_direction):
	match p_direction:
		Direction.SOUTH:
			return likelihood_down
		Direction.SOUTH_WEST:
			return likelihood_down_to_side
		Direction.SOUTH_EAST:
			return likelihood_down_to_side
		_:
			return 0.0


func is_match_direction(p_direction):
	match p_direction:
		Direction.SOUTH:
			return true
		Direction.SOUTH_WEST:
			return true
		Direction.SOUTH_EAST:
			return true
		_:
			return false


func get_interaction():
	return [element_other, element_self]
