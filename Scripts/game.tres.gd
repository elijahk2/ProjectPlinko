# How to add a new peg type:
# 1) Upload the image to the Ball_Peg assets folder, duplicate the normal_peg scene, and change the Sprite2D texture to the new image.
# 2) Rename the nodes accordingly, and make a new group to add the StaticBody2D to. Make sure you do this!
# 3) Modify create_peg_layout() function to account for the new peg's mechanics, and add a new elif to add it to procedural generation!

#Augments: ["Normal", "Bounce House", "Killbox", "Polygon Peril", "Ride or Die"]

extends Node2D

#Procedural Peg Generation
const NormalPeg = preload("res://Scenes/Peg Scenes/normal_peg.tscn") #Load peg scenes to spawn in
const GoldenPeg = preload("uid://dbmsssat1qfgf")
const RocketPeg = preload("uid://d0hb3yrpeycik")
const IronPeg = preload("uid://bho7vy7jev0wa")
const BulletPeg = preload("uid://c8nbrn2ocqto4")
const HurtPeg = preload("uid://jxo4i4rmh0c1")
const KillPeg = preload("uid://bp4cvbqoaw20s")

@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var endzone: CollisionShape2D = $Endzone/CollisionShape2D
@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var bounce_sfx: AudioStreamPlayer = $BounceSFX
@onready var charge_display: Label = $"Background Control/ChargeDisplay"
@onready var score_display: Label = $"Background Control/ScoreDisplay"
@onready var player: RigidBody2D = $Player
@onready var tutorial_label: Label = $TutorialLabel

var number_of_rows_array = [100, 200, 300] #Arrays will set their corresponding variable based on the settings chosen in mod menu
var spawn_chance_array = [8, 5, 3]
var number_of_rows = 300
var spawn_positions = [0,0,0,0,0,0,0,0,0,0]
var spawn_chance = 5 # 1/spawn_chance = probability of spawning a peg on any given tile of a row
var spawn_chance_increase = 0.5
var spawn_chance_increase_row_interval = number_of_rows / 10
var special_chance = 20 # 1/special_chance = probability a peg will have a modifier
var row = 0 #Define iteration var
var y_offset = 200 #Y distance between each row of 
var instance = 0 #Clear var for storing node to spawn
var is_bullet_out = false
var current_augment = -1
var board_array = []
var timescale = 1
var is_in_tutorial = 0
var tutorial_req_drops

func create_peg_layout():
	while row < number_of_rows: #Repeat until all rows generated
		row += 1 #increase iteration var
		spawn_positions = [0,0,0,0,0,0,0,0,0,0] #Reset spawn map
		for n in spawn_positions.size():
			if randi_range(1,spawn_chance) == 1: #Randomly choose peg or empty
				spawn_positions[n] = 1 #Fill spawn map with choice in location
				var peg_choice = randi_range(1, special_chance) #Choose peg type to spawn in
				if current_augment == 0 or current_augment == 3: #If Normal Augment
					if peg_choice == 1:
						if randi_range(1,2) == 1:
							instance = HurtPeg.instantiate()
						else:
							instance = GoldenPeg.instantiate()
					elif peg_choice == 2 and row > number_of_rows / 6:
						instance = RocketPeg.instantiate()
					elif peg_choice == 3 and row > number_of_rows / 3:
						instance = IronPeg.instantiate()
					elif peg_choice == 4 and row > number_of_rows / 4:
						#instance = BulletPeg.instantiate()
						pass #BulletPegs removed until further notice, as they disrupt the natural flow of the game and make it less fun.
					else:
						instance = NormalPeg.instantiate()
				elif current_augment == 1: #Is Bounce House Augment
					if randi_range(1, 5) == 1:
						instance = RocketPeg.instantiate()
					else:
						instance = NormalPeg.instantiate()
				elif current_augment == 2: #Is Killbox Augment
					if randi_range(1, 8) == 1 and row >= 5:
						instance = KillPeg.instantiate()
					else:
						if randi_range(1, 5) == 1:
							instance = GoldenPeg.instantiate()
						else:
							instance = NormalPeg.instantiate()
				elif current_augment == 4: #Is Ride or Die Augment
					if randi_range(1,2) == 1:
						instance = GoldenPeg.instantiate()
					else:
						instance = HurtPeg.instantiate()
				instance.position = Vector2(75 * n - 340, y_offset * row) #340 = 375 - 1/2 Peg Width to fill row
				self.add_child(instance) #Finish node creation
				board_array.append(instance.point_value) #Each peg has a point value set in their scenes
				if row % spawn_chance_increase_row_interval == number_of_rows % spawn_chance_increase_row_interval:
					spawn_chance += spawn_chance_increase
	Globals.calculate_max_possible_score(board_array) #Send the board to Globals for it to then add it together for sanity checks.
	
func _ready():
	score_display.add_theme_constant_override("shadow_offset_x", 1)
	score_display.add_theme_constant_override("shadow_offset_y", 2)
	score_display.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.6))
	charge_display.add_theme_constant_override("shadow_offset_x", 1)
	charge_display.add_theme_constant_override("shadow_offset_y", 2)
	charge_display.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 1.0))
	Engine.time_scale = timescale
	MusicManager.change_to_game_scene()
	spawn_chance = spawn_chance_array[Globals.settings[0]]
	number_of_rows = number_of_rows_array[Globals.settings[1]]
	current_augment = Globals.settings[2]
	var end_y = y_offset * (number_of_rows + 1) #The y pos that the ball must reach to finish
	score_display.position.x = -300
	charge_display.position.x = -300
	create_peg_layout()
	Globals.get_end_y(end_y)
	Globals.update_searched_for_leaderboard()
	camera_2d.limit_bottom = end_y - y_offset * 3 #Add 3 rows padding so the ball falls offscreen
	#background_music.play()
	
func _physics_process(delta: float) -> void:
	var half_width = tutorial_label.size.x / 2
	var target_x = player.position.x - half_width
	tutorial_label.position = Vector2(
		clamp(target_x, -340, 335 - tutorial_label.size.x),
		player.position.y + 150
	)
	
func _process(delta: float) -> void:
	if Globals.dead:
		charge_display.hide()
		score_display.hide()
	if score_display.position.x < 96.5:
		score_display.position.x += 4
	else:
		score_display.position.x = 96.5
	if charge_display.position.x < 112:
		charge_display.position.x += 4
	else:
		charge_display.position.x = 112
	tutorial_req_drops = Globals.num_drops #Set the number of drops required before tutorial runs. For testing. Set to 1 for release.
	if Globals.num_drops == tutorial_req_drops and player.position.y > 1000 and is_in_tutorial == 0:
		run_tutorial1()
	if Globals.num_drops == tutorial_req_drops and player.position.y > 3000 and is_in_tutorial == 2:
		run_tutorial2()
	if is_in_tutorial == 1:
		if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
			tutorial_label.text = ""
			Engine.time_scale = timescale
			is_in_tutorial = 2
	if is_in_tutorial == 3:
		if Input.is_action_just_pressed("push") and (Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("up") or Input.is_action_pressed("down")):
			tutorial_label.text = ""
			Engine.time_scale = timescale
			is_in_tutorial = 4
			
func run_tutorial1():
	Engine.time_scale = 0.3
	tutorial_label.text = "Left/Right to nudge the ball"
	is_in_tutorial = 1

func run_tutorial2():
	Engine.time_scale = 0.3
	tutorial_label.text = "Dash using Jump + Left/Right/Up/Down"
	is_in_tutorial = 3
