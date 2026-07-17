extends Node
#This node manages scene-to-scene interactions because it is set as a "global script"
#It acts as a sort of hub between scenes and nodes.

signal leaderboard_updated
signal toggle_leaderboard_label(is_visible: bool)

#initialize achievement vars:
var num_drops
var num_completed_drops
var fiftyfifty_unlocked
var highriser_unlocked
var neo_unlocked
var perfectionist_unlocked
var num_gold_pegs_hit
var num_peg_bounces

var leaderboard_modifiers = [0,0,0]
var leaderboard = []
var sfx_player: AudioStreamPlayer
var title_song_player = AudioStreamPlayer
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
var player_skin = 0
var volume = 1
var color_shift_speed = 8
var title_balls_toggle = true
var colorblind = false
var title_song = preload("res://Assets/Sound/Music/Plinko Title Song V1.mp3") #CHANGE THIS TO NEW SONGS

var last_played_drop_length = 0
var last_played_density = 0
var last_played_augment = 0

#Vars for match recap
var pegs_hit
var points_gained
var points_removed
var max_score
var result

var max_name_length = 15

signal score_changed(new_score) # Define a signal to modify ScoreDisplay's score value

var AppID = "4865760"
var boardHandle: int
var id

func _init():
	OS.set_environment("SteamAppID", AppID)
	OS.set_environment("SteamGameID", AppID)
	var init = Steam.steamInit()
	Steam.leaderboard_find_result.connect(leaderboard_result) #Connect the function with Steam's leaderboard finding code
	Steam.leaderboard_score_uploaded.connect(on_score_uploaded)
	Steam.leaderboard_scores_downloaded.connect(on_scores_downloaded)
	Steam.user_stats_received.connect(_on_user_stats_recieved)
	user_steam_id = Steam.getSteamID()
	Steam.requestUserStats(user_steam_id)
func _ready():
	sfx_player = AudioStreamPlayer.new()
	title_song_player = AudioStreamPlayer.new()
	title_song.loop = true
	title_song_player.stream = title_song
	add_child(sfx_player)
	add_child(title_song_player)
	title_song_player.play()
func _process(delta: float) -> void:
	Steam.run_callbacks()
func _on_user_stats_recieved(game_id, result, user_id):
	if result == Steam.RESULT_OK:
		#ACHIEVEMENT VARS:
		num_drops = Steam.getStatInt("ACH_1")
		num_completed_drops = Steam.getStatInt("ACH_2")
		fiftyfifty_unlocked = Steam.getStatInt("ACH_3")
		highriser_unlocked = Steam.getStatInt("ACH_4")
		neo_unlocked = Steam.getStatInt("ACH_5")
		perfectionist_unlocked = Steam.getStatInt("ACH_6")
		num_gold_pegs_hit = Steam.getStatInt("ACH_7/8")
		num_peg_bounces = Steam.getStatInt("ACH_11") #Achievements 9 and 10 use ACH_1
	else:
		print("Stats retrieval failed. Result: " + str(result))
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
func report_suspicious_score(score: int, max_possible: int) -> void: #HOLY VIBECODED BUT IT WORKS. Reports the score, name, and id to my discord server.
	var url = "https://discord.com/api/webhooks/1520095396817272995/oQZxW9sVDiXrhvkTyFPH4SjN5kJuRnpoDzvEWPPb4Sm6DdLYrzkkqad3_xabB8MzroRm"
	var steam_name = Steam.getPersonaName()
	var steam_id = Steam.getSteamID()
	
	var http := HTTPRequest.new()
	add_child(http)
	var body = JSON.stringify({
		"content": "⚠️ Flagged score: **%d** (max possible: %d)\nPlayer: **%s**\nSteam ID: `%s`" % [score, max_possible, steam_name, steam_id]
	})
	http.request(url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
func on_scores_downloaded(message, this_board, result):
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
			if score_to_add > highscore and highscore != null:
				Steam.uploadLeaderboardScore(score_to_add, true, [], boardHandle)
			else:
				score_changing = 0
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
func change_ball_num(change):
	num_balls += change
func get_end_y(value):
	end_y = value
	num_drops += 1
	Steam.setStatInt("ACH_1", num_drops) #Increment the number of drops initiated as this code runs at each drop start
	Steam.storeStats()
func set_label_visibility(is_visible: bool):
	toggle_leaderboard_label.emit(is_visible)
func set_skin(id): #Func called when the player selects a skin from the Skins menu. Var is pulled from ball.tscn at game start
	player_skin = id
func get_match_recap(num_pegs_hit, num_points_gained, num_points_removed, win_lose, gold_pegs, peg_bounces):
	pegs_hit = num_pegs_hit
	points_gained = num_points_gained
	points_removed = num_points_removed
	max_score = max_possible_score
	result = win_lose
	num_gold_pegs_hit += gold_pegs
	num_peg_bounces += peg_bounces
	Steam.setStatInt("ACH_7/8", num_gold_pegs_hit)
	Steam.setStatInt("ACH_11", num_peg_bounces)
	Steam.storeStats()
	if result:
		num_completed_drops += 1
		Steam.setStatInt("ACH_2", num_completed_drops) #Update the user's number of completed drops bc this runs at the end of each round
		Steam.storeStats()
		if settings == [2, 2, 2]:
			Steam.setStatInt("ACH_5", 1) #Update the user's number of completed drops bc this runs at the end of each round
			Steam.storeStats()
func bounce_above_top():
	Steam.setStatInt("ACH_4", 1) #Called by the Ball scene to unlock the purple skin.
	Steam.storeStats()
func register_fiftyfifty_unlock():
	Steam.setStatInt("ACH_3", 1) #update whether or not the player has gotton a B or higher
	Steam.storeStats()
func register_perfectionist_unlock():
	Steam.setStatInt("ACH_6", 1) #update whether or not the player has gotton an sss rank
	Steam.storeStats()	
func _input(event):
	if event.is_action_pressed("screenshot") and user_steam_id == 0: #replace with your steam id
		var capture = get_viewport().get_texture().get_image()
		capture.save_png("C:/Users/Hides2023/Desktop/Plinko Screenshots" + str(Time.get_unix_time_from_system()) + ".png")
		print("Screenshot saved!")
func update_settings(volume_setting, color_shift_setting, title_balls_setting, colorblind_setting):
	volume = volume_setting / 100.0
	color_shift_speed = color_shift_setting
	title_balls_toggle = title_balls_setting
	colorblind = colorblind_setting
	var bus_index = AudioServer.get_bus_index("Bounce SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume / 2))
	bus_index = AudioServer.get_bus_index("Title Cursor SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume / 2))
