class_name Interaction
extends InteractionBase
# Used for most complicated interactions. Sibling classes will implement
# particularly common interactions, e.g. InteractionFall. Includes various
# common behaviors.

# A selection of common behaviors:
#	SWAP = The current grain takes the place of the other grain, and vice versa
#	REPLACE_SELF = The current grain is replaced by the new grain type
#	REPLACE_OTHER = The other grain is replaced by the new grain type
#	REPLACE_BOTH = Both grains are replaced by the new grain type
# TODO: add more
enum Behavior { SWAP, REPLACE_SELF, REPLACE_OTHER, REPLACE_BOTH }

export var direction = Direction.DOWN
export(Behavior) var behavior = Behavior.SWAP
export(Resource) var grain_type_new = null
export(float, 0, 1) var likelihood = 1.0
export(Resource) var grain_type_self = null
export(Resource) var grain_type_other = null


func get_grain_type_self():
	return grain_type_self


func get_grain_type_other():
	return grain_type_other


func get_likelihood(p_direction):
	return likelihood


func is_match_direction(p_direction):
	return p_direction == direction


func get_interaction(input):
	match behavior:
		Behavior.SWAP:
			return [input[1], input[0]]
		Behavior.REPLACE_SELF:
			return [grain_type_new, input[1]]
		Behavior.REPLACE_OTHER:
			return [input[0], grain_type_new]
		Behavior.REPLACE_BOTH:
			return [grain_type_new, grain_type_new]
