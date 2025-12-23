extends Control

func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	pass
func _on_QuitButton_pressed():
	get_tree().quit()
	pass
