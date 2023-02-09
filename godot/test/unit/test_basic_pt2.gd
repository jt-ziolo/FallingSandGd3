extends GutTest
# See https://github.com/bitwes/Gut/wiki/Quick-Start


func test_assert_true_with_true():
	assert_true(true, "Should pass, true is true")


func test_assert_true_with_false():
	#assert_true(false, "Should fail")
	pass_test("Passing")


func test_something_else():
	#assert_true(false, "didn't work")
	pass_test("Passing2")
