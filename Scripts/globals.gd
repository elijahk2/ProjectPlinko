extends Node

var sfx_player: AudioStreamPlayer
var settings = []
signal score_changed(new_score) # Define a signal to modify ScoreDisplay's score value

func _ready():
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "Title SFX"
	add_child(sfx_player)

func play_title_start_sfx():
	sfx_player.stream = load("res://Assets/Sound/SFX/stringy.wav")
	sfx_player.play()
	
func bullet_peg_point_increment():
	score_changed.emit(1) #Send 1 so the label knows to increase score by one

func prepare_settings(density, length, augment):
	settings = [density, length, augment]
