extends Control

@onready var stats_label_1: Label = $StatsLabel1
@onready var stats_label_2: Label = $StatsLabel2
@onready var stats_label_3: Label = $StatsLabel3
@onready var stats_label_4: Label = $StatsLabel4
@onready var your_rank_is_label: Label = $YourRankIsLabel
@onready var ranking_label: Label = $RankingLabel
@onready var header: Label = $Header1

var label_start_x = -300
var label_vel = 500
var header_start_y = -300
var is_intro_done = 0
var is_outro_done = -1 #-1 represents uninitiated outro
var i = 0
var percentage_of_max = 0
var rank = "Nothing yet loser"

#Vars to be gotten from Globals
var pegs_hit
var points_gained
var points_removed
var max_score

func get_match_recap_from_globals():
	pegs_hit = Globals.pegs_hit
	points_gained = Globals.points_gained
	points_removed = Globals.points_removed
	max_score = Globals.max_score

func _ready() -> void:
	var curve = 20
	header.position.y = header_start_y
	stats_label_1.position.x = label_start_x
	stats_label_2.position.x = label_start_x
	stats_label_3.position.x = label_start_x
	stats_label_4.position.x = label_start_x
	your_rank_is_label.position.x = label_start_x
	ranking_label.position.x = label_start_x
	get_match_recap_from_globals()
	stats_label_1.text = "Pegs Hit: " + str(pegs_hit)
	stats_label_2.text = "Points Gained: " + str(points_gained)
	stats_label_3.text = "Points Removed: " + str(points_removed)
	stats_label_4.text = "Overall Score: " + str(points_gained - points_removed)
	percentage_of_max = ((float(points_gained - points_removed)) / max_score * 100) + curve
	if percentage_of_max > 50:
		Globals.register_fiftyfifty_unlock()
	if percentage_of_max >= 98:
		Globals.register_perfectionist_unlock()
	if percentage_of_max <= 10:
		rank = "F"
	elif percentage_of_max <= 30:
		rank = "D"
	elif percentage_of_max <= 50:
		rank = "C"
	elif percentage_of_max <= 70:
		rank = "B"
	elif percentage_of_max <= 85:
		rank = "A"
	elif percentage_of_max <= 93:
		rank = "S"
	elif percentage_of_max <= 98:
		rank = "SS"
	else:
		rank = "SSS"
	ranking_label.text = rank
	Globals.rank = rank #Send the rank result to Globals
	Globals.req_stats()
	Globals.check_register_f_tier_controlfreak_unlock()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	if Input.is_action_just_pressed("push") and is_intro_done == 1:
		Globals.play_cursor_move_sfx()
		is_outro_done = 0

	if is_outro_done == 0:
		if stats_label_1.position.x > label_start_x:
			stats_label_1.position.x -= label_vel * delta / 1.5
		else:
			stats_label_1.position.x = label_start_x

		if stats_label_2.position.x > label_start_x:
			stats_label_2.position.x -= label_vel * delta / 2
		else:
			stats_label_2.position.x = label_start_x

		if stats_label_3.position.x > label_start_x:
			stats_label_3.position.x -= label_vel * delta / 2.5
		else:
			stats_label_3.position.x = label_start_x

		if stats_label_4.position.x > label_start_x:
			stats_label_4.position.x -= label_vel * delta / 3
		else:
			stats_label_4.position.x = label_start_x

		if your_rank_is_label.position.x > label_start_x:
			your_rank_is_label.position.x -= label_vel * delta / 2.5
		else:
			your_rank_is_label.position.x = label_start_x

		if ranking_label.position.x > label_start_x:
			ranking_label.position.x -= label_vel * delta / 2
		else:
			ranking_label.position.x = label_start_x

		if header.position.y > header_start_y:
			header.position.y -= label_vel * delta / 2
		else:
			header.position.y = header_start_y

		# Once everything is back offscreen, leave the recap screen
		if stats_label_1.position.x == label_start_x \
		and stats_label_2.position.x == label_start_x \
		and stats_label_3.position.x == label_start_x \
		and stats_label_4.position.x == label_start_x \
		and your_rank_is_label.position.x == label_start_x \
		and ranking_label.position.x == label_start_x \
		and header.position.y == header_start_y:
			is_outro_done = 1
			get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")

	if is_intro_done == 0:
		if stats_label_1.position.x < 10:
			stats_label_1.position.x += label_vel * delta / 1.5
		else:
			stats_label_1.position.x = 10

		if stats_label_2.position.x < 10:
			stats_label_2.position.x += label_vel * delta / 2
		else:
			stats_label_2.position.x = 10

		if stats_label_3.position.x < 10:
			stats_label_3.position.x += label_vel * delta / 2.5
		else:
			stats_label_3.position.x = 10

		if stats_label_4.position.x < 10:
			stats_label_4.position.x += label_vel * delta / 3
		else:
			stats_label_4.position.x = 10
			is_intro_done = 1

		if your_rank_is_label.position.x < 52:
			your_rank_is_label.position.x += label_vel * delta / 2.5
		else:
			your_rank_is_label.position.x = 52

		if ranking_label.position.x < 114:
			ranking_label.position.x += label_vel * delta / 2
		else:
			ranking_label.position.x = 114

		if header.position.y < -2:
			header.position.y += label_vel * delta / 2
		else:
			header.position.y = -2
