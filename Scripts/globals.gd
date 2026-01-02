extends Node

var sfx_player: AudioStreamPlayer

func _ready():
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "Title SFX"
	add_child(sfx_player)
	
func play_title_start_sfx():
	sfx_player.stream = load("res://Assets/Sound/SFX/stringy.wav")
	sfx_player.play()
