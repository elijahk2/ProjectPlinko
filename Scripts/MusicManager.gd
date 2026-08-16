extends Node
var game_scene = "Main"
var music_player = AudioStreamPlayer.new()
var current_loop = 0
var main_song_intro_and_part_1 = preload("uid://cgmu46yltsla3")
var main_song_part_2 = preload("uid://cbmoahhkwplx5")

func _ready():
	change_to_main_scene()

func fade_out(player: AudioStreamPlayer, duration: float = 1):
	var tween = create_tween()
	tween.tween_property(player, "volume_linear", 0.0, duration)
	tween.tween_callback(func(): print("fade finished, freeing"))
	await tween.finished
	tween.tween_callback(player.queue_free)
	

func change_to_main_scene():
	if music_player.is_inside_tree():
		await fade_out(music_player)
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
	if music_player.is_inside_tree():
		await fade_out(music_player)
	game_scene = "Game"
	music_player = AudioStreamPlayer.new()
	music_player.bus = "BG Music"
	music_player.finished.connect(_on_music_finished)
	music_player.stream = main_song_intro_and_part_1 #THis will become the in-drop music
	add_child(music_player)
	music_player.play()
