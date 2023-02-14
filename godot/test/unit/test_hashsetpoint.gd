extends GutTest

const HashSetPoint = preload("res://scripts/HashSetPoint.cs")
var _hashset: HashSetPoint


func before_each():
	_hashset = HashSetPoint.new()


func after_each():
	_hashset.free()


func test_hashsetpoint_clear():
	assert_false(_hashset.Contains(1, 1))
	_hashset.Add(1, 1)
	_hashset.Add(2, 2)
	_hashset.Add(3, 3)
	assert_true(_hashset.Contains(1, 1))
	assert_true(_hashset.Contains(2, 2))
	assert_true(_hashset.Contains(3, 3))
	_hashset.Clear()
	assert_false(_hashset.Contains(1, 1))
	assert_false(_hashset.Contains(2, 2))
	assert_false(_hashset.Contains(3, 3))


func test_hashsetpoint_add_contains():
	assert_false(_hashset.Contains(1, 2))
	_hashset.Add(1, 2)
	assert_false(_hashset.Contains(1, 1))
	assert_true(_hashset.Contains(1, 2))


func test_hashsetpoint_remove():
	assert_false(_hashset.Contains(1, 2))
	_hashset.Add(1, 2)
	assert_true(_hashset.Contains(1, 2))
	_hashset.Remove(1, 2)
	assert_false(_hashset.Contains(1, 2))
