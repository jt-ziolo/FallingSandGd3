class_name HelperFunctions


static func nonmut_shuffle(array):
	var copy_array = array.duplicate()  # TODO: Is deep copy needed?
	copy_array.shuffle()
	return copy_array


static func add_points(point_a, point_b):
	var result = [point_a[0] + point_b[0], point_a[1] + point_b[1]]
	return result
