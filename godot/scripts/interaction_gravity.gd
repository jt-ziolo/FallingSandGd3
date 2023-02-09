class_name InteractionGravity
extends InteractionBase
# Simulates one grain falling into another (or empty space). The likelihood of
# the grain "spreading out" (falling in the down/left and down/right
# directions) is controlled by a separate likelihood variable than just falling
# straight down.

export(Resource) var export_grain_type_self = null
export(Resource) var export_grain_type_other = null 
export(float, 0, 1) var likelihood_down = 1.0
export(float, 0, 1) var likelihood_down_to_side = 0.05 


# See interaction_base.gd, grid.gd
func is_match(input, p_direction, random_0_to_1):
	grain_type_self = export_grain_type_self
	grain_type_other = export_grain_type_other
	match p_direction:
		Direction.DOWN: 
			if random_0_to_1 > likelihood_down:
				return false
		Direction.DOWN_LEFT:
			if random_0_to_1 > likelihood_down_to_side:
				return false
		Direction.DOWN_RIGHT:
			if random_0_to_1 > likelihood_down_to_side:
				return false
		_:
			return false;
	var result = true
	result = result and (input[0] == grain_type_self)
	result = result and (input[1] == grain_type_other)
	return result


# See interaction_base.gd, grid.gd
func apply_interaction(input):
	return [input[1], input[0]]
