extends RigidBody2D

@onready var mini_hit_sound: AudioStreamPlayer = $AudioStreamPlayer

const MiniBullet = preload("uid://csblsch6lhyfy")
var has_spawned_bullet = false  # Prevent infinite spawning

func _ready():
	has_spawned_bullet = false

func _on_body_entered(body):
	if body.is_in_group("all_pegs") and body.collision_layer == 1:

		#mini_hit_sound.play()
		
		if body.is_in_group("rocket_pegs"):
			apply_impulse(Vector2(0, -2500), Vector2(0,0))
		
		Globals.bullet_peg_point_increment()
