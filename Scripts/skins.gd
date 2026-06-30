extends Control

@onready var cursor: Sprite2D = $Cursor
@onready var skin_req_label: Label = $SkinReqLabel
@onready var skins_display: AnimatedSprite2D = $SkinsDisplay

var cursor_start_x = 37
var cursor_start_y = 37
var cursor_offset_x = 60
var cursor_offset_y = 75
var cursor_x = 0
var cursor_y = 0

var skin_req_text: Array = [
	"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12",
	"13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24",
	"25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prepare_skin_display()
	cursor.position = Vector2(cursor_start_x, cursor_start_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	skin_req_label.text = skin_req_text[cursor_x + (cursor_y * 6)]
	cursor.position = Vector2(cursor_start_x + (cursor_offset_x * cursor_x), cursor_start_y + (cursor_offset_y * cursor_y))
	if Input.is_action_just_pressed("back"):
		get_tree().change_scene_to_file( "res://Scenes/title_screen.tscn")
	if Input.is_action_just_pressed("up") and cursor_y > 0:
		cursor_y -= 1
	if Input.is_action_just_pressed("down") and cursor_y < 5:
		cursor_y += 1
	if Input.is_action_just_pressed("left") and cursor_x > 0:
		cursor_x -= 1
	if Input.is_action_just_pressed("right") and cursor_x < 5:
		cursor_x += 1

func prepare_skin_display():
	skins_display.hide()
	var x = 0
	var y = 0
	var num_frames = skins_display.sprite_frames.get_frame_count("SkinsAnimation")
	for i in num_frames:
		var instance = skins_display.duplicate()
		instance.show()
		instance.frame = i
		instance.position = Vector2(
			cursor_start_x + (cursor_offset_x * x), 
			cursor_start_y + (cursor_offset_y * y)
		)
		add_child(instance)
		x += 1
		if x >= 6:
			x = 0
			y += 1
