extends StaticBody2D

func _process(delta):
	if self.collision_layer == 2:
		modulate.a -= delta * 2
		if modulate.a <= 0:
			queue_free()
