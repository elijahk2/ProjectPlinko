extends Node

var screen_type = "Windowed"

func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	DisplayServer.window_set_size(Vector2i(375, 750))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if screen_type == "Windowed":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			screen_type = "Fullscreen"
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			screen_type = "Windowed"
