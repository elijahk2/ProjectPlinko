extends Node

#This node manages scene-to-scene interactions because it is set as a "global script"
#It acts as a sort of hub between scenes and nodes.

var leaderboard_modifiers = [0,0,0]
var leaderboard = []
var sfx_player: AudioStreamPlayer
var settings = []
var song_notes = [1, 1.2, 1.4, 1.6, 1.8, 1.6, 1.4, 1.2] #Defines the song played when the cursor moves on the title screen
var song_notes_id = 0
var num_balls = 0
var end_y = 0
var user_highscore = 0
var user_steam_id: int
var score_changing = 0
var score_to_add = 0
var highscore = 0
signal score_changed(new_score) # Define a signal to modify ScoreDisplay's score value

var AppID = "4865760"
var boardHandle: int
var id

func _init():
	var init = Steam.steamInit()
	OS.set_environment("SteamAppID", AppID)
	OS.set_environment("SteamGameID", AppID)
	Steam.leaderboard_find_result.connect(leaderboard_result) #Connect the function with Steam's leaderboard finding code
	Steam.leaderboard_score_uploaded.connect(on_score_uploaded)
	Steam.leaderboard_scores_downloaded.connect(on_scores_downloaded)
	
func _ready():
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	user_steam_id = Steam.getSteamID()

func _process(delta: float) -> void:
	Steam.run_callbacks()

func get_modifiers_for_leaderboard(modifiers):
	leaderboard_modifiers = modifiers # keep as array

func update_searched_for_leaderboard():
	var a = leaderboard_modifiers[0]
	var b = leaderboard_modifiers[1]
	var c = leaderboard_modifiers[2]
	var leaderboard_name = str(a) + ", " + str(b) + ", " + str(c)
	Steam.findLeaderboard(leaderboard_name)
	print(leaderboard_name)

func get_leaderboard(): #Recieve the leaderboard corresponding with the modifiers from the steam database
	return leaderboard
	
func add_item_to_leaderboard(score):
	if boardHandle == 0:
		print("No board handle yet!")
		return
	score_changing = 1
	score_to_add = score
	Steam.downloadLeaderboardEntries(0, 0, Steam.LEADERBOARD_DATA_REQUEST_GLOBAL_AROUND_USER, boardHandle)
	

func leaderboard_result(handle, found): #Check if the leaderboard is found
	if found:
		boardHandle = handle
		print(boardHandle)
		print("FOUND!")
		Steam.downloadLeaderboardEntries(1, 10, Steam.LEADERBOARD_DATA_REQUEST_GLOBAL, boardHandle)
	else:
		print("not found...")
		leaderboard = []
		leaderboard_updated.emit()

signal leaderboard_updated

func on_scores_downloaded(message, this_board, result): #Download the scores from the leaderboard
	print(score_changing)
	print(result)
	if score_changing == 1:
		if result.size() > 0:
			highscore = result[0]["score"]
		else:
			Steam.uploadLeaderboardScore(score_to_add, true, [], boardHandle)
			return
		print(highscore)
		print(score_to_add)
		if score_to_add > highscore:
			print("new high score!")
			Steam.uploadLeaderboardScore(score_to_add, true, [], boardHandle)
	leaderboard = []
	for entry in result:
		leaderboard.append({
			"name": Steam.getFriendPersonaName(entry["steam_id"]),
			"score": entry["score"],
			"steam_id": entry["steam_id"]
		})
	leaderboard_updated.emit()
	score_changing = 0

func on_score_uploaded(success, was_changed, this_score): #Handle response for uploaded scores
	if success:
		print("Score uploaded!")
	else:
		print("Upload failed.")

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
