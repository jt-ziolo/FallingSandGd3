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

export var direction = Direction.SOUTH
export(Behavior) var behavior = Behavior.SWAP
export(Resource) var element_new = null
export(float, 0, 1) var likelihood = 1.0
export(Resource) var element_self = null
export(Resource) var element_other = null


func get_element_self():
	return element_self


func get_element_other():
	return element_other


func get_likelihood(p_direction):
	return likelihood


func is_match_direction(p_direction):
	return p_direction == direction


func get_interaction():
	match behavior:
		Behavior.SWAP:
			return [element_other, element_new]
		Behavior.REPLACE_SELF:
			return [element_new, element_other]
		Behavior.REPLACE_OTHER:
			return [element_new, element_new]
		Behavior.REPLACE_BOTH:
			return [element_new, element_new]
