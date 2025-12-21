extends RigidBody2D

@onready var hit_sound = $AudioStreamPlayer # Path to your sound node

func _ready():
	hit_sound.pitch_scale = 0.9
	self.set_collision_mask_value(1, true)
	self.set_collision_mask_value(2, false)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("pegs"):
		hit_sound.pitch_scale = hit_sound.pitch_scale + 0.1
		hit_sound.play()
		body.set_collision_layer_value(1, false)
		body.set_collision_layer_value(2, true)
		body.collision_mask = 0
