extends Control

#WARNING: IN INTRO CODE, LOTS OF HARDCODED VALUES. THESE ARE BASED OFF THEIR END POSITIONS AFTER INTRO

@onready var peg_density_header: Label = $"Peg Density Header"
@onready var drop_length_header: Label = $"Drop Length Header"
@onready var augment_header: Label = $"Augment Header"
@onready var peg_density_display: Label = $"Peg Density Header/Peg Density Display"
@onready var drop_length_display: Label = $"Drop Length Header/Drop Length Display"
@onready var augment_display: Label = $"Augment Header/Augment Display"
@onready var cursor: Sprite2D = $Cursor
@onready var header_1: Label = $Header1
@onready var drop_label: Label = $"DROP!"

var cursor_y = 1 #Use 1 for Density row, 2 for Length, 3 for Augment
var intro_done = false
var labels_done = false
var game_starting_animation = false
var header_cursor_drop_done = false
var label_init_offset = -250 #How far to move the labels on the x axis before sliding on screen
var label_vel = 0

var density = ["Low", "Medium", "High"] #Store possible display options for Density
var density_id = 1 #Reference array's items by this ID

var length = ["Short", "Medium", "Long"] #Store possible display options for Length
var length_id = 0

var augment = ["Normal", "BounceHouse", "Killbox", "ControlFreak", "Ride or Die"] #Store possible display options for Augment
var augment_id = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	density_id = Globals.last_played_density
	length_id = Globals.last_played_drop_length
	augment_id = Globals.last_played_augment
	cursor.position.x = 400 #slightly higher than the right edge of the screen
	header_1.position.y = label_init_offset
	drop_label.position.y = 775
	peg_density_header.position.x = label_init_offset
	drop_length_header.position.x = label_init_offset
	augment_header.position.x = label_init_offset
	peg_density_display.position.x = label_init_offset + 55 #55 = distance that the actual values are offset from the headers.
	drop_length_display.position.x = label_init_offset + 55
	augment_display.position.x = label_init_offset + 55

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("back"): #Manage returning to title screen
		Globals.play_cursor_move_sfx()
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	
	peg_density_display.text = density[density_id % density.size()] #Update Density label's text
	drop_length_display.text = length[length_id % length.size()] #Update Length label's text
	augment_display.text = augment[augment_id % augment.size()] #Update Augment label's text
	
	#Intro management logic
	if labels_done == false: 
		label_vel += 10
		if peg_density_header.position.x < 11: #Normal x pos for headers
			peg_density_header.position.x += label_vel * delta
			drop_length_header.position.x += label_vel * delta
			augment_header.position.x += label_vel * delta
		else:
			intro_done = true #End intro and give player control again.
		if peg_density_display.position.x < 50: #Normal x pos for displays
			peg_density_display.position.x += label_vel * delta
			drop_length_display.position.x += label_vel * delta
			augment_display.position.x += label_vel * delta
		if header_1.position.y < 10:
			header_1.position.y += label_vel * delta
		if drop_label.position.y > 557:
			drop_label.position.y -= label_vel * delta
		if cursor.position.x > 292:
			cursor.position.x -= label_vel * delta

	if game_starting_animation == true:
		label_vel += 5
		header_1.position.y -= 4 * label_vel * delta
		drop_label.position.y -= label_vel * delta
		peg_density_display.position.y -= label_vel * delta
		peg_density_header.position.y -= label_vel * delta
		drop_length_display.position.y -= label_vel * delta
		drop_length_header.position.y -= label_vel * delta
		augment_display.position.y -= label_vel * delta
		augment_header.position.y -= label_vel * delta
		cursor.position.y -= label_vel * delta
		if drop_label.position.y < -100: #Ensure DROP! is off the screen
			get_tree().change_scene_to_file("res://Scenes/game.tscn")
		

	if intro_done == true and game_starting_animation == false: #Menu management logic for after intro/before game start
		cursor.position = Vector2(289, 192 + 130 * (cursor_y - 1)) 
		#Set the cursor's position to 292 (the right x value) and y incrementing based on the current cursor_y value.
			
		if Input.is_action_just_pressed("down") and cursor_y < 4:
			cursor_y += 1
			Globals.play_cursor_move_sfx()
		if Input.is_action_just_pressed("up") and cursor_y > 1:
			cursor_y -= 1
			Globals.play_cursor_move_sfx()
		if Input.is_action_just_pressed("right"): #These two if statements can be shortened with negative multiplication, etc.
			if cursor_y == 1:
				density_id += 1
			elif cursor_y == 2:
				length_id += 1
			elif cursor_y == 3:
				augment_id += 1
			if cursor_y != 4:
				Globals.play_cursor_move_sfx()
		if Input.is_action_just_pressed("left"):
			if cursor_y == 1:
				density_id -= 1
			elif cursor_y == 2:
				length_id -= 1
			elif cursor_y == 3:
				augment_id -= 1
			if cursor_y != 4:
				Globals.play_cursor_move_sfx()
				
		if Input.is_action_just_pressed("push") and cursor_y == 4:
			var modifiers = [density_id, length_id, augment_id]
			Globals.get_modifiers_for_leaderboard(modifiers)
			Globals.prepare_settings(density_id % density.size(), length_id % length.size(), augment_id % augment.size())
			Globals.set_last_settings(density_id % density.size(), length_id % length.size(), augment_id % augment.size())
			Globals.play_title_start_sfx()
			#get_tree().change_scene_to_file("res://Scenes/game.tscn")
			label_vel = 0
			game_starting_animation = true
			
		
