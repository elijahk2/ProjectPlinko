extends StaticBody2D

var health = 10 #How many hits an iron peg can take before it breaks
var point_value = 0

func _ready() -> void:
	if is_in_group("golden_pegs"):
		point_value = 5
	elif is_in_group("iron_pegs"):
		point_value = 10
	elif not is_in_group("hurt_pegs"):
		point_value = 1
		
func _process(delta):
	#Manage peg break special effect when ball.gd modifies collision_layer property of peg hit
	if self.collision_layer == 2:
		modulate.a -= delta * 4
		if modulate.a <= 0:
			queue_free()
