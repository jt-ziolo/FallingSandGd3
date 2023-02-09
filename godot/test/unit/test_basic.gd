extends GutTest
# See https://github.com/bitwes/Gut/wiki/Quick-Start


func before_each():
	gut.p("ran setup", 2)


func after_each():
	gut.p("ran teardown", 2)


func before_all():
	gut.p("ran run setup", 2)


func after_all():
	gut.p("ran run teardown", 2)


func test_assert_eq_number_not_equal():
	#assert_eq(1, 2, "Should fail.  1 != 2")
	pass_test("Passing3")


func test_assert_eq_number_equal():
	assert_eq("asdf", "asdf", "Should pass")
