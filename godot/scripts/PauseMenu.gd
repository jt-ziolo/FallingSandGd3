extends TextureRect


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		self.visible = !self.visible
