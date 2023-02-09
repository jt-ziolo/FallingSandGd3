class_name HelperFunctions

static func nonmut_shuffle(array):
	var copy_array = array.duplicate() # Is deep copy needed?
	copy_array.shuffle()
	return copy_array
