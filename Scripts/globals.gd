extends Node

#This node manages scene-to-scene interactions because it is set as a "global script"
#It acts as a sort of hub between scenes and nodes.

var leaderboard = []
var sfx_player: AudioStreamPlayer
var settings = []
var song_notes = [1, 1.2, 1.4, 1.6, 1.8, 1.6, 1.4, 1.2] #Defines the song played when the cursor moves on the title screen
var song_notes_id = 0
var num_balls = 0
var end_y = 0
signal score_changed(new_score) # Define a signal to modify ScoreDisplay's score value

var AppID = "480" #Change to our unique appid after $100 purchase
var boardHandle: int
var id

func _init():
	var init = Steam.steamInit()
	OS.set_environment("SteamAppID", AppID)
	OS.set_environment("SteamGameID", AppID)
	Steam.leaderboard_find_result.connect(leaderboard_result) #Connect the function with Steam's leaderboard finding code
	Steam.leaderboard_score_uploaded.connect(on_score_uploaded)
	
func _ready():
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	Steam.findLeaderboard("1") #Change this once we make actual leaderboards
	
func leaderboard_result(handle, found): #Check if the leaderboard is found
	if found:
		boardHandle = handle
		print("FOUND!")
		Steam.downloadLeaderboardEntries(1, 10, Steam.LEADERBOARD_DATA_REQUEST_GLOBAL, boardHandle)
		Steam.leaderboard_scores_downloaded.connect(on_scores_downloaded)
	else:
		print("not found...")

func on_scores_downloaded(message, this_board, result): #Download the scores from the leaderboard
	leaderboard = []
	for entry in result:
		leaderboard.append({
			"name": Steam.getFriendPersonaName(entry["steam_id"]),
			"score": entry["score"],
			"steam_id": entry["steam_id"]
		})

func on_score_uploaded(success, was_changed, this_score): #Handle response for uploaded scores
	if success:
		print("Score uploaded!")
	else:
		print("Upload failed.")

func _process(delta: float) -> void:
	Steam.run_callbacks()

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

func get_modifiers_for_leaderboard(modifiers): #Recieve the ids for the settings the player wants to see lb for
	var leaderboard_modifiers = modifiers

func get_leaderboard(): #Recieve the leaderboard corresponding with the modifiers from the steam database
	return leaderboard
	
func add_item_to_leaderboard(score):
	if boardHandle == 0:
		print("No board handle yet!")
		return
	Steam.uploadLeaderboardScore(score, true, [], boardHandle)
	
func remove_item_from_leaderboard():
	pass
