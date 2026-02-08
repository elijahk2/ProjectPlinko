extends Node

#This node manages scene-to-scene interactions because it is set as a "global script"

var sfx_player: AudioStreamPlayer
var settings = []
var song_notes = [1, 1.2, 1.4, 1.6, 1.8, 1.6, 1.4, 1.2] #Defines the song played when the cursor moves on the title screen
var song_notes_id = 0
var num_balls = 0
var end_y = 0
signal score_changed(new_score) # Define a signal to modify ScoreDisplay's score value

func _ready():
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)

func play_title_start_sfx():
	sfx_player.bus = "Title Play SFX"
	sfx_player.pitch_scale = 1
	sfx_player.stream = load("res://Assets/Sound/SFX/stringy.wav")
	sfx_player.play()

func play_cursor_move_sfx():
	sfx_player.bus = "Bounce SFX"
	song_notes_id += 1
	sfx_player.pitch_scale = song_notes[song_notes_id % song_notes.size()] - 0.2 #Select the proper note to play for the title scale
	sfx_player.stream = load("res://Assets/Sound/SFX/BounceSound.wav")
	sfx_player.play()

func play_bounce_sfx(): #Called when a ball on the title screen hits the ground
	sfx_player.bus = "Title Bounce SFX"
	sfx_player.pitch_scale = randf_range(1, 1.4)
	sfx_player.stream = load("res://Assets/Sound/SFX/BounceSound.wav")
	sfx_player.play()

	
func bullet_peg_point_increment():
	score_changed.emit(1) #Send 1 so the label knows to increase score by one

func prepare_settings(density, length, augment):
	settings = [density, length, augment]
	print(settings)
	
func change_ball_num(change):
	num_balls += change
	
func get_end_y(value):
	end_y = value
