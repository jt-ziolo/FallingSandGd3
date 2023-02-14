extends GutTest

const HelperFunctions = preload("res://scripts/helper_functions.gd")


func test_nonmut_shuffle():
	# 7! permutations = 5040, unlikely to get a false positive
	var array = [1, 2, 3, 4, 5, 6, 7]
	var shuffled = HelperFunctions.nonmut_shuffle(array)
	assert_ne(array, shuffled, "shuffled should not match original")
	assert_eq(array, [1, 2, 3, 4, 5, 6, 7], "original array changed")
	assert_eq(array.size(), shuffled.size(), "size mismatch")
	gut.p(shuffled)


func test_nonmut_shuffle_performance():
	var time_start = Time.get_ticks_usec()
	for i in range(50):
		var array = [1, 2, 3, 4, 5, 6, 7]
		var shuffled = HelperFunctions.nonmut_shuffle(array)
	var time_end = Time.get_ticks_usec()
	var time_difference = time_end - time_start
	gut.p(
		"#### Manually check performance. For 50 calls, took {0} microseconds, {1} average".format(
			[time_difference, time_difference / 50.0]
		)
	)
	pass_test("Passed")
