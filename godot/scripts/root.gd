extends Control


func _ready():
	#Engine.time_scale = 1.5
	Engine.target_fps = 40


func _on_ButtonQuit_pressed():
	get_tree().quit()
