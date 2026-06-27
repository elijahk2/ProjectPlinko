extends StaticBody2D

var health = 10 #How many hits an iron peg can take before it breaks

func _process(delta):
	#Manage peg break special effect when ball.gd modifies collision_layer property of peg hit
	if self.collision_layer == 2:
		modulate.a -= delta * 4
		if modulate.a <= 0:
			queue_free()
