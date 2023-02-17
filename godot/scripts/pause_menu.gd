extends TextureRect


signal pause_toggled(is_paused)

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		self.visible = !self.visible
		emit_signal("pause_toggled", self.visible)
