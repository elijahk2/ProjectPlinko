extends RigidBody2D

@onready var hit_sound = $AudioStreamPlayer # Path to your sound node
@onready var score_display: Label = $"../Background Control/ScoreDisplay"
@onready var animated_bg: AnimatedSprite2D = $"../Background Control/Background/AnimatedSprite2D"
@onready var endzone: CollisionShape2D = $"../Area2D/Endzone"

var dash_ready = 1

const dash_power = 1200
const tap_power = 2

func _ready():
	position.x = randi_range(-200, 200)
	hit_sound.pitch_scale = 0.9
	self.set_collision_mask_value(1, true)
	self.set_collision_mask_value(2, false)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("pegs"):
		hit_sound.pitch_scale = hit_sound.pitch_scale + 0.1
		var frame_count = animated_bg.sprite_frames.get_frame_count("BG Color Shift")
		animated_bg.frame = (animated_bg.frame + 1) % frame_count
		if animated_bg.frame == 0:
			animated_bg.frame = 1
		hit_sound.play()
		body.set_collision_layer_value(1, false)
		body.set_collision_layer_value(2, true)
		body.collision_mask = 0
		score_display.score += 1
	if body == endzone:
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
		
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
		
