extends Node
#This node manages scene-to-scene interactions because it is set as a "global script"
#It acts as a sort of hub between scenes and nodes.

signal leaderboard_updated
signal toggle_leaderboard_label(is_visible: bool)

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
var max_possible_score = 0

var last_played_drop_length = 0
var last_played_density = 0
var last_played_augment = 0

var max_name_length = 15

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
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	user_steam_id = Steam.getSteamID()

func _process(delta: float) -> void:
	Steam.run_callbacks()

func set_last_settings(density, length, augment):
	last_played_density = density
	last_played_drop_length = length
	last_played_augment = augment

func get_modifiers_for_leaderboard(modifiers):
	leaderboard_modifiers = modifiers # keep as array

func update_searched_for_leaderboard():
	var a = leaderboard_modifiers[0]
	var b = leaderboard_modifiers[1]
	var c = leaderboard_modifiers[2]
	var leaderboard_name = str(a) + ", " + str(b) + ", " + str(c)
	Steam.findLeaderboard(leaderboard_name)
	print("Leaderboard Name: " + str(leaderboard_name))

func get_leaderboard(): #Recieve the leaderboard corresponding with the modifiers from the steam database
	set_label_visibility(false)
	return leaderboard
	
func add_item_to_leaderboard(score):
	score_changing = 1
	score_to_add = score
	update_searched_for_leaderboard()

func leaderboard_result(handle, found): #Check if the leaderboard is found
	if found:
		boardHandle = handle
		print("LEADERBOARD FOUND! HANDLE: " + str(boardHandle))
		set_label_visibility(true)
		Steam.downloadLeaderboardEntries(1, 10, Steam.LEADERBOARD_DATA_REQUEST_GLOBAL, boardHandle)
	else:
		print("LEADERBOARD NOT FOUND! CHECK IF IT EXISTS IN STEAMWORKS")
		leaderboard = []
		leaderboard_updated.emit()

func calculate_max_possible_score(board):
	max_possible_score = board.reduce(func(accum, x): return accum + x, 0) #Add the sum of all the pegs, excluding red, together, to see what the max potential score is.
	print("MAX SCORE POSSIBLE: " + str(max_possible_score))

var url = "https://discord.com/api/webhooks/1520095396817272995/oQZxW9sVDiXrhvkTyFPH4SjN5kJuRnpoDzvEWPPb4Sm6DdLYrzkkqad3_xabB8MzroRm"
func report_suspicious_score(score: int, max_possible: int) -> void: #HOLY VIBECODED BUT IT WORKS. Reports the score, name, and id to my discord server.
	var steam_name = Steam.getPersonaName()
	var steam_id = Steam.getSteamID()
	
	var http := HTTPRequest.new()
	add_child(http)
	var body = JSON.stringify({
		"content": "⚠️ Flagged score: **%d** (max possible: %d)\nPlayer: **%s**\nSteam ID: `%s`" % [score, max_possible, steam_name, steam_id]
	})
	http.request(url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
		
func on_scores_downloaded(message, this_board, result):
	print("is the score changing? " + str(score_changing))
	print("Leaderboard returns: " + str(result))
	if score_to_add <= max_possible_score:
		if score_changing == 1:
			var current_player_score = null
			for entry in result:
				if entry["steam_id"] == user_steam_id:
					current_player_score = entry["score"]
					break
			if current_player_score != null:
				highscore = current_player_score
			else:
				Steam.uploadLeaderboardScore(score_to_add, true, [], boardHandle)
				return
			print("Your Highscore: " + str(highscore))
			print("Your Recent Score: " + str(score_to_add))
			if score_to_add > highscore:
				Steam.uploadLeaderboardScore(score_to_add, true, [], boardHandle)
		leaderboard = []
		for entry in result:
			var name = Steam.getFriendPersonaName(entry["steam_id"])
			var name_limited = "stuff"
			if name.length() > 15:
				name_limited = name.left(max_name_length) + "..."
			else:
				name_limited = name
			leaderboard.append({
				"name": name_limited,
				"score": entry["score"],
				"steam_id": entry["steam_id"]
			})
		leaderboard_updated.emit()
		score_changing = 0
	else:
		print("Score rejected. Exceeds max possible.")
		report_suspicious_score(score_to_add, max_possible_score)

func on_score_uploaded(success, was_changed, this_score): #Handle response for uploaded scores
	if success:
		print("Score uploaded!")
	else:
		print("Score upload failed.")

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
	print("Modifier Settings: " + str(settings))
	
func change_ball_num(change):
	num_balls += change
	
func get_end_y(value):
	end_y = value

func set_label_visibility(is_visible: bool):
	toggle_leaderboard_label.emit(is_visible)
