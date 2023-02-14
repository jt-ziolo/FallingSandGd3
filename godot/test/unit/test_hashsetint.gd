extends GutTest

const HashSetInt = preload("res://scripts/HashSetInt.cs")
var _hashset: HashSetInt


func before_each():
	_hashset = HashSetInt.new()


func after_each():
	_hashset.free()


func test_hashsetint_add_contains():
	assert_false(_hashset.Contains(1))
	_hashset.Add(1)
	assert_false(_hashset.Contains(2))
	assert_true(_hashset.Contains(1))


func test_hashsetint_clear():
	assert_false(_hashset.Contains(1))
	_hashset.Add(1)
	_hashset.Add(2)
	_hashset.Add(3)
	assert_true(_hashset.Contains(1))
	assert_true(_hashset.Contains(2))
	assert_true(_hashset.Contains(3))
	_hashset.Clear()
	assert_false(_hashset.Contains(1))
	assert_false(_hashset.Contains(2))
	assert_false(_hashset.Contains(3))


func test_hashsetint_remove():
	assert_false(_hashset.Contains(1))
	assert_false(_hashset.Contains(2))
	_hashset.Add(1)
	assert_true(_hashset.Contains(1))
	assert_false(_hashset.Contains(2))
	_hashset.Remove(1)
	assert_false(_hashset.Contains(1))
	assert_false(_hashset.Contains(2))
	_hashset.Add(1)
	_hashset.Add(2)
	_hashset.Remove(1)
	assert_false(_hashset.Contains(1))
	assert_true(_hashset.Contains(2))
