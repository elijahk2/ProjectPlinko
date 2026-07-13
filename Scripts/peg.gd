extends StaticBody2D

var health = 10 #How many hits an iron peg can take before it breaks
var point_value = 0
var colorblind = Globals.colorblind
var gold_texture
var hurt_texture
var iron_texture
var kill_texture
var rocket_texture
var normal_texture = load("res://Assets/Art/Ball_Peg/white-ball-test.png")

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
		#Code to load textures:
	if colorblind:
		gold_texture = load("res://Assets/Art/Ball_Peg/GoldenPeg_CB.png")
		hurt_texture = load("res://Assets/Art/Ball_Peg/HurtPeg_CB.png")
		iron_texture = load("res://Assets/Art/Ball_Peg/IronPeg_CB.png")
		kill_texture = load("res://Assets/Art/Ball_Peg/KillPeg_CB.png")
		rocket_texture = load("res://Assets/Art/Ball_Peg/RocketPeg_CB.png")
	else:
		gold_texture = load("res://Assets/Art/Ball_Peg/GoldenPeg.png")
		hurt_texture = load("res://Assets/Art/Ball_Peg/HurtPeg.png")
		iron_texture = load("res://Assets/Art/Ball_Peg/IronPeg.png")
		kill_texture = load("res://Assets/Art/Ball_Peg/KillPeg.png")
		rocket_texture = load("res://Assets/Art/Ball_Peg/RocketPeg.png")

	# 2. Assign point values and textures based on groups
	if is_in_group("golden_pegs"):
		point_value = 5
		sprite_2d.texture = gold_texture
	elif is_in_group("iron_pegs"):
		point_value = 10
		sprite_2d.texture = iron_texture
	elif is_in_group("hurt_pegs"):
		point_value = -5 # Adjust as needed for penalty
		sprite_2d.texture = hurt_texture
	elif is_in_group("kill_pegs"):
		point_value = 0 # Or whatever makes sense for a "kill" peg
		sprite_2d.texture = kill_texture
	elif is_in_group("rocket_pegs"):
		point_value = 15
		sprite_2d.texture = rocket_texture
	else:
		# Default fallback for regular pegs
		point_value = 1
		sprite_2d.texture = normal_texture
		
func _process(delta):
	#Manage peg break special effect when ball.gd modifies collision_layer property of peg hit
	if self.collision_layer == 2:
		modulate.a -= delta * 4
		if modulate.a <= 0:
			queue_free()
