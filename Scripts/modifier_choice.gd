extends Control

@onready var peg_density_display: Label = $"Peg Density Header/Peg Density Display"
@onready var drop_length_display: Label = $"Drop Length Header/Drop Length Display"
@onready var augment_display: Label = $"Augment Header/Augment Display"
@onready var cursor: Sprite2D = $Cursor

var cursor_y = 1 #Use 1 for Density row, 2 for Length, 3 for Augment

var density = ["Low", "Medium", "High"] #Store possible display options for Density
var density_id = 1 #Reference array's items by this ID

var length = ["Short", "Medium", "Long"] #Store possible display options for Length
var length_id = 0

var augment = ["Normal"] #Store possible display options for Augment
var augment_id = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	peg_density_display.text = density[density_id % density.size()] #Update Density label's text
	drop_length_display.text = length[length_id % length.size()] #Update Length label's text
	augment_display.text = augment[augment_id % augment.size()] #Update Augment label's text
	
	cursor.position = Vector2(292, 192 + 130 * (cursor_y - 1)) 
	#Set the cursor's position to 292 (the right x value) and y incrementing based on the current cursor_y value.
		
	if Input.is_action_just_pressed("down") and cursor_y < 4:
		cursor_y += 1
	if Input.is_action_just_pressed("up") and cursor_y > 1:
		cursor_y -= 1
	if Input.is_action_just_pressed("right"): #These two if statements can be shortened with negative multiplication, etc.
		if cursor_y == 1:
			density_id += 1
		elif cursor_y == 2:
			length_id += 1
		elif cursor_y == 3:
			augment_id += 1
	if Input.is_action_just_pressed("left"):
		if cursor_y == 1:
			density_id -= 1
		elif cursor_y == 2:
			length_id -= 1
		elif cursor_y == 3:
			augment_id -= 1
	
	if Input.is_action_just_pressed("push") and cursor_y == 4:
		Globals.prepare_settings(density_id % density.size(), length_id % length.size(), augment_id % augment.size())
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
		
