#TO ADD A NEW SKIN:
#Add the frame to the animated sprite in skins.tscn AND the ball.tscn scene.
#Add the appropriate trail color in ball.tscn/particle node.
#Ensure there is a tick variable in Globals for whether or not it has been unlocked.
#Add an unlock function and setStat. Then, add an elif statement below for if Globals.tick_var == 1: and then unlock the skin!

extends Control

@onready var skin_locked: Sprite2D = $SkinLockedSymbol
@onready var selected_skin: Sprite2D = $SelectedSkinSymbol
@onready var cursor: Sprite2D = $Cursor
@onready var skin_req_label: Label = $SkinReqLabel
@onready var skins_display: AnimatedSprite2D = $SkinsDisplay

var cursor_start_x = 37
var cursor_start_y = 37
var cursor_offset_x = 60
var cursor_offset_y = 75
var cursor_x = 0
var cursor_y = 0
var selected_skin_x = 0
var selected_skin_y = 0
var id

var skin_req_text: Array = [
	"Get going! There are skins to unlock!",
	"Still Green:\nStart your first drop.",
	"Bottom Breakout:\nComplete your first drop.",
	"The Bee's Knees:\nObtain a B rank or higher.",
	"High Riser:\nBounce off the top of the screen.",
	"Neo:\nHave invincibility and endurance.",
	"Perfectionist:\nObtain an SSS rank.",
	"Making Bank:\nHit a total of 100 Golden Pegs",
	"Gold Digger:\nHit a total of 500 Golden Pegs",
	"Insanity:\nComplete 25 drops.",
	"Touch Grass:\nComplete 100 drops.",
	"Baller:\nBounce off 1000 pegs.",
	"Ball Knowledge:\nBounce off 5000 pegs",
	"Claim the Bronze Star from the title screen.",
	"Claim the Silver Star from the title screen.",
	"Claim the Gold Star from the title screen.",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon",
	"Coming Soon"
]
var skin_unlock_status: Array = [
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
]

func _ready() -> void:
	selected_skin_x = Globals.player_skin % 6
	selected_skin_y = Globals.player_skin / 6
	set_unlock_status()
	prepare_skin_display()
	cursor.position = Vector2(cursor_start_x, cursor_start_y)

func _process(delta: float) -> void:
	id = cursor_x + (cursor_y * 6)
	skin_req_label.text = skin_req_text[id]
	cursor.position = Vector2(cursor_start_x + (cursor_offset_x * cursor_x), cursor_start_y + (cursor_offset_y * cursor_y)) # Move the cursor based on the cursor_x/cursor_y values
	selected_skin.position = Vector2(cursor_start_x + (cursor_offset_x * selected_skin_x), cursor_start_y + (cursor_offset_y * selected_skin_y)) # Place the translucent grey check on the location of the selected skin
	if Input.is_action_just_pressed("back"):
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	if Input.is_action_just_pressed("up") and cursor_y > 0:
		cursor_y -= 1
		Globals.play_cursor_move_sfx()
	if Input.is_action_just_pressed("down") and cursor_y < 5:
		cursor_y += 1
		Globals.play_cursor_move_sfx()
	if Input.is_action_just_pressed("left") and cursor_x > 0:
		cursor_x -= 1
		Globals.play_cursor_move_sfx()
	if Input.is_action_just_pressed("right") and cursor_x < 5:
		cursor_x += 1
		Globals.play_cursor_move_sfx()
	if Input.is_action_just_pressed("push") and skin_unlock_status[id] == 1:
		Globals.set_skin(id)
		Globals.id = id
		selected_skin_x = cursor_x
		selected_skin_y = cursor_y
		Globals.play_cursor_move_sfx()
func prepare_skin_display():
	skins_display.hide()
	var x = 0
	var y = 0
	var num_frames = skins_display.sprite_frames.get_frame_count("SkinsAnimation")
	for i in num_frames:
		var instance = skins_display.duplicate()
		var lock_instance = skin_locked.duplicate()
		instance.show()
		instance.frame = i
		instance.position = Vector2(
			cursor_start_x + (cursor_offset_x * x),
			cursor_start_y + (cursor_offset_y * y)
		)
		add_child(instance)
		if skin_unlock_status[i] == 0:
			lock_instance.show()
			lock_instance.position = Vector2(
				cursor_start_x + (cursor_offset_x * x),
				cursor_start_y + (cursor_offset_y * y)
			)
			add_child(lock_instance)
		x += 1
		if x >= 6:
			x = 0
			y += 1
func set_unlock_status():
	Globals.req_stats()
	for i in range(35):
		if i == 0:
			skin_unlock_status[i] = 1
		elif i == 1:
			if Globals.num_drops > 0:
				skin_unlock_status[i] = 1
		elif i == 2:
			if Globals.num_completed_drops > 0:
				skin_unlock_status[i] = 1
		elif i == 3:
			if Globals.fiftyfifty_unlocked:
				skin_unlock_status[i] = 1
		elif i == 4:
			if Globals.highriser_unlocked:
				skin_unlock_status[i] = 1
		elif i == 5:
			if Globals.neo_unlocked:
				skin_unlock_status[i] = 1
		elif i == 6:
			if Globals.perfectionist_unlocked:
				skin_unlock_status[i] = 1
		elif i == 7:
			if Globals.num_gold_pegs_hit >= 100:
				skin_unlock_status[i] = 1
		elif i == 8:
			if Globals.num_gold_pegs_hit >= 500:
				skin_unlock_status[i] = 1
		elif i == 9:
			if Globals.num_completed_drops >= 25:
				skin_unlock_status[i] = 1
		elif i == 10:
			if Globals.num_completed_drops >= 100:
				skin_unlock_status[i] = 1
		elif i == 11:
			if Globals.num_peg_bounces >= 1000:
				skin_unlock_status[i] = 1
		elif i == 12:
			if Globals.num_peg_bounces >= 5000:
				skin_unlock_status[i] = 1
		elif i == 13:
			if Globals.bronze_star_unlocked == 1:
				skin_unlock_status[i] = 1
		elif i == 14:
			if Globals.silver_star_unlocked == 1:
				skin_unlock_status[i] = 1
		elif i == 15:
			if Globals.gold_star_unlocked == 1:
				skin_unlock_status[i] = 1
