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
enum Behavior {
	SWAP,
	REPLACE_SELF,
	REPLACE_OTHER,
	REPLACE_BOTH
}


export(Resource) var export_grain_type_self = null
export(Resource) var export_grain_type_other = null 
export var export_direction = Direction.DOWN
export(Behavior) var behavior = Behavior.SWAP
export(Resource) var export_grain_type_new = null
export(float, 0, 1) var export_likelihood = 1.0


# TODO: setting these here does not seem to work
func _ready():
	grain_type_self = export_grain_type_self
	grain_type_other = export_grain_type_other
	direction = export_direction
	grain_type_new = export_grain_type_new
	likelihood = export_likelihood


# See interaction_base.gd, grid.gd
func apply_interaction(input):
	match behavior:
		Behavior.SWAP:
			return [input[1], input[0]]
		Behavior.REPLACE_SELF:
			return [grain_type_new, input[1]]
		Behavior.REPLACE_OTHER:
			return [input[0], grain_type_new]
		Behavior.REPLACE_BOTH:
			return [grain_type_new, grain_type_new]
