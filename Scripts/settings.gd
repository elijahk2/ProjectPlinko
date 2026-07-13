extends Control

var volume_setting = 100
var color_shift_speed_setting = 8
var title_screen_balls_toggle = true
var colorblind_toggle = true
var cursor_y = 0
var settings_offset = 67
var delay = 0 #How many frames until the setting can be changed again
var delay_reset = 30 #What to set delat to each change

@onready var volume_label: Label = $Volume
@onready var color_shift_label: Label = $"Color Shift"
@onready var title_balls_label: Label = $"Title Balls"
@onready var colorblind_label: Label = $Colorblind
@onready var cursor: Sprite2D = $Cursor

func _ready() -> void:
	volume_setting = int(Globals.volume * 100)
	color_shift_speed_setting = Globals.color_shift_speed
	title_screen_balls_toggle = Globals.title_balls_toggle
	colorblind_toggle = Globals.colorblind
	pass

func _process(delta: float) -> void:
	if delay > 0:
		delay -= 1
	volume_label.text = "Volume: " + str(volume_setting)
	color_shift_label.text = "Color Speed: " + str(color_shift_speed_setting)
	if colorblind_toggle:
		colorblind_label.text = "Colorblind: ON"
	else:
		colorblind_label.text = "Colorblind: OFF"
	if title_screen_balls_toggle:
		title_balls_label.text = "Title Balls: ON"
	else:
		title_balls_label.text = "Title Balls: OFF"
	
	cursor.position.y = 47.5 + settings_offset * cursor_y
	
	if Input.is_action_just_pressed("back"):
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	if Input.is_action_just_pressed("up") and cursor_y > 0:
		cursor_y -= 1
	if Input.is_action_just_pressed("down") and cursor_y < 3:
		cursor_y += 1
	if Input.is_action_pressed("left"): #Keystroke management for Left
		if cursor_y == 0: #Volume setting
			volume_setting -= 1
		elif cursor_y == 1  and delay == 0:  #Color shift settings
			color_shift_speed_setting -= 1
			delay = delay_reset
		elif cursor_y == 2 and delay == 0: #Turn on/off title screen balls toggle
			if title_screen_balls_toggle:
				title_screen_balls_toggle = false
			else:
				title_screen_balls_toggle = true
			delay = delay_reset
		elif cursor_y == 3 and delay == 0: #Turn on/off colorblind mode
			if colorblind_toggle:
				colorblind_toggle = false
			else:
				colorblind_toggle = true
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
		elif cursor_y == 3 and delay == 0:
			if colorblind_toggle:
				colorblind_toggle = false
			else:
				colorblind_toggle = true
			delay = delay_reset
	if volume_setting > 200.0:
		volume_setting = 200
	if volume_setting < 0:
		volume_setting = 0
	if color_shift_speed_setting > 16:
		color_shift_speed_setting = 16
	if color_shift_speed_setting < 1:
		color_shift_speed_setting = 1
		
	Globals.update_settings(volume_setting, color_shift_speed_setting, title_screen_balls_toggle, colorblind_toggle)
	#Send the  variables to Globals  so that they can be  distributed to scenes and utilized
