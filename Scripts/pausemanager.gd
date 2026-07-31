extends Node

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		if not get_tree().paused:
			get_tree().paused = true
		else:
			get_tree().paused = false
	if get_tree().paused and Input.is_action_just_pressed("push"):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
