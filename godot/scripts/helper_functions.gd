class_name HelperFunctions


static func nonmut_shuffle(array):
	var copy_array = array.duplicate()  # TODO: Is deep copy needed?
	copy_array.shuffle()
	return copy_array


static func add_points(point_a, point_b):
	var result = [point_a[0] + point_b[0], point_a[1] + point_b[1]]
	return result


static func sort_ascending(point_a, point_b):
	# Return true if b should be after a
	return point_b[1] < point_a[1]
