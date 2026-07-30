extends Node

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		if not get_tree().paused:
			get_tree().paused = true
		else:
			get_tree().paused = false
