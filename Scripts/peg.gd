extends StaticBody2D

func _process(delta):
	#Manage peg break special effect when ball.gd modifies collision_layer property of peg hit
	if self.collision_layer == 2:
		modulate.a -= delta * 4
		if modulate.a <= 0:
			queue_free()
