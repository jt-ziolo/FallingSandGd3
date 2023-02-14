extends GutTest

var _brush: Brush
const ACTIONS = ["paint", "element_previous", "element_next"]


func before_each():
	_brush = load("res://scripts/brush.gd").new()
	_brush.elements = []
	for i in [["1st", Color.red], ["2nd", Color.green], ["3rd", Color.blue]]:
		var element = Element.new()
		element.human_friendly_name = i[0]
		element.color = i[1]
		_brush.elements.append(element)
	_brush.selected_element = _brush.elements[0]
	_brush._ready()


func test_element_initially_selected():
	assert_eq(_brush.selected_element, _brush.elements[0])


func test_full_wrap():
	assert_eq(_brush.selected_element, _brush.elements[0])
	_brush._scroll_element(false)
	_brush._scroll_element(false)
	_brush._scroll_element(false)
	assert_eq(_brush.selected_element, _brush.elements[0])
	_brush._scroll_element(true)
	_brush._scroll_element(true)
	_brush._scroll_element(true)
	assert_eq(_brush.selected_element, _brush.elements[0])


func test_previous():
	assert_eq(_brush.selected_element, _brush.elements[0])
	_brush._scroll_element(false)
	assert_eq(_brush.selected_element, _brush.elements[2])


func test_next():
	assert_eq(_brush.selected_element, _brush.elements[0])
	_brush._scroll_element(true)
	assert_eq(_brush.selected_element, _brush.elements[1])


func after_each():
	_brush.free()
