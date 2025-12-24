extends RigidBody2D

@onready var hit_sound = $AudioStreamPlayer # Path to your sound node
@onready var score_display: Label = $"../Background Control/ScoreDisplay"
@onready var animated_bg: AnimatedSprite2D = $"../Background Control/Background/AnimatedSprite2D"
@onready var charge_display: Label = $"../Background Control/ChargeDisplay"

var dash_ready = 1.0

const dash_power = 1200
const tap_power = 2

# scale settings
const octave_limit = 3.0
const init_pitch_scale = 0.7
var scale_degree = 0

func _ready():
	#Set random x position, reset pitch, reset collision management
	position.x = randi_range(-200, 200)
	hit_sound.pitch_scale = 1
	self.set_collision_mask_value(1, true)
	self.set_collision_mask_value(2, false)
	body_entered.connect(_on_body_entered)
	charge_display.text = str(100 * dash_ready) + "%" 

func _on_body_entered(body):
	if body.is_in_group("all_pegs") and body.collision_layer == 1: #Check for re-collisions
		if not body.is_in_group("iron_pegs"): #Safeguard against deleting iron pegs
			body.set_collision_layer_value(1, false) #Prevent re-colliding during fadeout animation
			body.set_collision_layer_value(2, true)
		#For some reason, collision layers of 2 were being registered as hits by mask 1 ball, so multiple safety checks are in place to prevent that.
		var frame_count = animated_bg.sprite_frames.get_frame_count("BG Color Shift")
		animated_bg.frame = (animated_bg.frame + 1) % frame_count
		if animated_bg.frame == 0:
			animated_bg.frame = 1
		
		# hit sound logic
		hit_sound.play()
		hit_sound.pitch_scale = init_pitch_scale * 2**(pitch_multiplier_power(scale_degree))
		scale_degree += 1
		
		if body.is_in_group("rocket_pegs"):
			apply_impulse(Vector2(0, -2500), Vector2(0,0))
		
		if body.is_in_group("golden_pegs"):
			score_display.score += 5
		else:
			score_display.score += 1
		if dash_ready < 0.9:
			dash_ready += 0.1
		
func _physics_process(delta: float) -> void:
	charge_display.text = str(100 * dash_ready) + "%" 
	#Manage key presses (>= 0.99 is used to prevent non-exact values for dash_ready)
	if Input.is_action_pressed("push") and dash_ready >= 0.99 and not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		apply_impulse(Vector2(0,(-1 * dash_power)), Vector2(0,0))
		dash_ready = 0
	if Input.is_action_pressed("left") and dash_ready >= 0.99:
		if Input.is_action_pressed("push"):
			apply_impulse(Vector2((-1 * dash_power), 0),Vector2(0,0))
			dash_ready = 0
		else:
			apply_impulse(Vector2((-1 * tap_power),0),Vector2(0,0))
	if Input.is_action_pressed("right"):
		if Input.is_action_pressed("push") and dash_ready >= 0.99:
			apply_impulse(Vector2(dash_power, 0),Vector2(0,0))
			dash_ready = 0
		else:
			apply_impulse(Vector2(tap_power,0),Vector2(0,0))
		
		
# major scale
func pitch_multiplier_power(degree: int) -> float:
	# major scale
	# const scale = [1.0, 1.0, 0.5, 1.0, 1.0, 1.0, 0.5]
	# minor scale
	# const scale = [1.0, 0.5, 1.0, 1.0, 0.5, 1.0, 1.0]
	# pentatonic scale
	const scale = [1.0, 1.0, 1.5, 1.0, 1.5]
	var octaves = degree / scale.size()
	degree %= scale.size()
	var power_part = 0.0
	var sum = 0
	for i in range(0, scale.size()):
		if degree == i:
			power_part = sum / 6.0
		sum += scale[i]
	var power = power_part + octaves
	#stops ascending at octave_limit
	if power > octave_limit:
		return octave_limit
	else:
		return power
