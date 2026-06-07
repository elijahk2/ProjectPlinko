extends Control
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"): #Return to title screen
		Globals.play_cursor_move_sfx()
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
		
