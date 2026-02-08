extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"): #Return to title screen
		Globals.play_cursor_move_sfx()
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
