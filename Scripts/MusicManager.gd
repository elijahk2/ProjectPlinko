extends Node
var game_scene = "Main"
var music_player
var current_loop = 0
var main_song_intro_and_part_1 = preload("uid://cgmu46yltsla3")
var main_song_part_2 = preload("uid://cbmoahhkwplx5")

func _ready():
	game_scene = "Main"
	music_player = AudioStreamPlayer.new()
	music_player.bus = "BG Music"
	music_player.finished.connect(_on_music_finished)
	music_player.stream = main_song_intro_and_part_1
	add_child(music_player)
	music_player.play()

func _on_music_finished():
	music_player.stream = main_song_part_2
	music_player.play()
	
func change_to_game_scene():
	game_scene = "Game"
