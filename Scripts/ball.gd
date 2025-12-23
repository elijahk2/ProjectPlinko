extends RigidBody2D

@onready var hit_sound = $AudioStreamPlayer # Path to your sound node
@onready var score_display: Label = $"../Background Control/ScoreDisplay"
@onready var animated_bg: AnimatedSprite2D = $"../Background Control/Background/AnimatedSprite2D"

var dash_ready = 1

const dash_power = 1200
const tap_power = 2

const init_pitch_scale = 0.8
var scale_degree = 0

func _ready():
	position.x = randi_range(-200, 200)
	hit_sound.pitch_scale = 1
	self.set_collision_mask_value(1, true)
	self.set_collision_mask_value(2, false)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("pegs"):
		var frame_count = animated_bg.sprite_frames.get_frame_count("BG Color Shift")
		animated_bg.frame = (animated_bg.frame + 1) % frame_count
		if animated_bg.frame == 0:
			animated_bg.frame = 1
		
		# hit sound logic
		hit_sound.play()
		hit_sound.pitch_scale = init_pitch_scale * 2**(pitch_multiplier_power(scale_degree))
		scale_degree += 1
		
		body.set_collision_layer_value(1, false)
		body.set_collision_layer_value(2, true)
		body.collision_mask = 0
		score_display.score += 1
		
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("push") and dash_ready == 1 and not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		apply_impulse(Vector2(0,(-1 * dash_power)), Vector2(0,0))
		dash_ready = 0
	if Input.is_action_pressed("left") and dash_ready == 1:
		if Input.is_action_pressed("push"):
			apply_impulse(Vector2((-1 * dash_power), 0),Vector2(0,0))
			dash_ready = 0
		else:
			apply_impulse(Vector2((-1 * tap_power),0),Vector2(0,0))
	if Input.is_action_pressed("right"):
		if Input.is_action_pressed("push") and dash_ready ==1:
			apply_impulse(Vector2(dash_power, 0),Vector2(0,0))
			dash_ready = 0
		else:
			apply_impulse(Vector2(tap_power,0),Vector2(0,0))
		
		
# major scale
func pitch_multiplier_power(degree: int) -> float:
	# const scale = [1.0, 1.0, 0.5, 1.0, 1.0, 1.0, 0.5]
	var octaves = degree / 7
	degree %= 7;  
	var power_part = 0.0;
	if degree == 0:
		power_part = 0.0
	if degree == 1:
		power_part = 1.0/6.0
	if degree == 2:
		power_part = 2.0/6.0
	if degree == 3:
		power_part = 5.0/12.0
	if degree == 4:
		power_part = 7.0/12.0
	if degree == 5:
		power_part = 9.0/12.0
	if degree == 6:
		power_part = 11.0/12.0
	var power = power_part + octaves
	#stops at two octaves higher
	if power > 2.0:
		return 2.0
	else:
		return power
