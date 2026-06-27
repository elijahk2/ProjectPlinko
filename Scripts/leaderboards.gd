extends Control
	
@onready var loading_label: Label = $LoadingLabel

func _ready() -> void:
	Globals.toggle_leaderboard_label.connect(_on_leaderboard_label_toggled)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"): #Return to title screen
		Globals.play_cursor_move_sfx()
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
		
func _on_leaderboard_label_toggled(is_visible: bool):
	loading_label.visible = is_visible
