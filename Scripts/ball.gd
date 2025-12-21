extends RigidBody2D

@onready var hit_sound = $AudioStreamPlayer # Path to your sound node
@onready var score_display: Label = $"../Background Control/ScoreDisplay"
@onready var animated_bg: AnimatedSprite2D = $"../Background Control/Background/AnimatedSprite2D"


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
