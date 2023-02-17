extends GutTest

var resource_path = [
	"res://scripts/grid.gd", 
	"res://scripts/brush.gd", 
	"res://scripts/draw.gd", 
	"res://scripts/color_rect_mouse.gd",
	"res://scripts/color_rect_gradient.gd",
	"res://scripts/label_formatted.gd",
]


func test_node(params = use_parameters(resource_path)):
	var node = partial_double(params).new()
	gut.p("Leak testing {0}".format([node.to_string()]))
	stub(node, "is_valid_point").to_return(true)
	node.free()
	assert_no_new_orphans()
