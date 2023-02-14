extends ColorRect
class_name ColorRectMouse


# TODO: Set the color to invert the screen color under the cursor
func _on_Brush_mouse_moved(mouse_position):
	self.set_global_position(Vector2(mouse_position[0] as float, mouse_position[1] as float))
