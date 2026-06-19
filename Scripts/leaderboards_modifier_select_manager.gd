extends Node

@onready var peg_density_display: Label = $"Peg Density Header/Peg Density Display"
@onready var drop_length_display: Label = $"Drop Length Header/Drop Length Display"
@onready var augment_display: Label = $"Augment Header/Augment Display"
@onready var cursor: Sprite2D = $Cursor
@onready var leaderboard_list: VBoxContainer = $"../VBoxContainer"


var cursor_y = 1 #Use 1 for Density row, 2 for Length, 3 for Augment

var density = ["Low", "Medium", "High"] #Store possible display options for Density
var density_id = 1 #Reference array's items by this ID

var length = ["Short", "Medium", "Long"] #Store possible display options for Length
var length_id = 0

var augment = ["Normal", "BounceHouse", "Killbox", "PolygonPeril (Not Implemented)", "Ride or Die"] #Store possible display options for Augment
var augment_id = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	density_id = Globals.leaderboard_modifiers[0]
	length_id = Globals.leaderboard_modifiers[1]
	augment_id = Globals.leaderboard_modifiers[2]
	Globals.update_searched_for_leaderboard()
	Globals.leaderboard_updated.connect(leaderboard_list.generate_leaderboard_table)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	peg_density_display.text = density[density_id % density.size()]
	drop_length_display.text = length[length_id % length.size()]
	augment_display.text = augment[augment_id % augment.size()]

	cursor.position = Vector2(292, 127 + 76 * (cursor_y - 1))

	if Input.is_action_just_pressed("down") and cursor_y < 3:
		cursor_y += 1
		_on_cursor_changed()
	if Input.is_action_just_pressed("up") and cursor_y > 1:
		cursor_y -= 1
		_on_cursor_changed()
	if Input.is_action_just_pressed("right"):
		if cursor_y == 1:
			density_id += 1
		elif cursor_y == 2:
			length_id += 1
		elif cursor_y == 3:
			augment_id += 1
		_on_cursor_changed()
	if Input.is_action_just_pressed("left"):
		if cursor_y == 1:
			density_id -= 1
		elif cursor_y == 2:
			length_id -= 1
		elif cursor_y == 3:
			augment_id -= 1
		_on_cursor_changed()

func _on_cursor_changed() -> void:
	Globals.play_cursor_move_sfx()
	var modifiers = [
		((density_id % density.size()) + density.size()) % density.size(),
		((length_id % length.size()) + length.size()) % length.size(),
		((augment_id % augment.size()) + augment.size()) % augment.size()
	]
	Globals.get_modifiers_for_leaderboard(modifiers)
	Globals.update_searched_for_leaderboard()
