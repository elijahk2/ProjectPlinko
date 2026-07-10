extends Control

var volume_setting = 100
var color_shift_speed_setting = 8
var title_screen_balls_toggle = true
var cursor_y = 0
var settings_offset = 67
var delay = 0 #How many frames until the setting can be changed again
var delay_reset = 30 #What to set delat to each change

@onready var volume_label: Label = $Volume
@onready var color_shift_label: Label = $"Color Shift"
@onready var cursor: Sprite2D = $Cursor
@onready var title_balls_label: Label = $"Title Balls"

func _ready() -> void:
	volume_setting = int(Globals.volume * 100)
	color_shift_speed_setting = Globals.color_shift_speed
	title_screen_balls_toggle = Globals.title_balls_toggle
	pass

func _process(delta: float) -> void:
	if delay > 0:
		delay -= 1
	volume_label.text = "Volume: " + str(volume_setting)
	color_shift_label.text = "Color Speed: " + str(color_shift_speed_setting)
	if title_screen_balls_toggle:
		title_balls_label.text = "Title Balls: ON"
	else:
		title_balls_label.text = "Title Balls: OFF"
	
	cursor.position.y = 47.5 + settings_offset * cursor_y
	
	if Input.is_action_just_pressed("back"):
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	if Input.is_action_just_pressed("up") and cursor_y > 0:
		cursor_y -= 1
	if Input.is_action_just_pressed("down") and cursor_y < 5:
		cursor_y += 1
	if Input.is_action_pressed("left"): #Keystroke management for Left
		if cursor_y == 0:
			volume_setting -= 1
		elif cursor_y == 1  and delay == 0:
			color_shift_speed_setting -= 1
			delay = delay_reset
		elif cursor_y == 2 and delay == 0:
			if title_screen_balls_toggle:
				title_screen_balls_toggle = false
			else:
				title_screen_balls_toggle = true
			delay = delay_reset
	if Input.is_action_pressed("right"): #Keystroke management for Right
		if cursor_y == 0:
			volume_setting += 1
		elif cursor_y == 1 and delay == 0:
			color_shift_speed_setting += 1
			delay = delay_reset
		elif cursor_y == 2 and delay == 0:
			if title_screen_balls_toggle:
				title_screen_balls_toggle = false
			else:
				title_screen_balls_toggle = true
			delay = delay_reset
	if volume_setting > 200:
		volume_setting = 200
	if volume_setting < 0:
		volume_setting = 0
	if color_shift_speed_setting > 16:
		color_shift_speed_setting = 16
	if color_shift_speed_setting < 1:
		color_shift_speed_setting = 1
		
	Globals.update_settings(volume_setting, color_shift_speed_setting, title_screen_balls_toggle)
