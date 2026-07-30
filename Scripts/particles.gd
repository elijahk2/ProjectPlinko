extends GPUParticles2D

var trail_colors = [Color(1.0, 1.0, 1.0, 1.0), Color(0.02, 0.796, 0.0, 1.0), Color(0.553, 0.365, 0.0, 1.0), 
					Color(0.376, 0.0, 0.557, 1.0), Color(0.729, 0.0, 1.0, 1.0), Color(0.784, 0.71, 0.541, 1.0), 
					Color(1.0, 1.0, 1.0, 1.0), Color(0.945, 0.769, 0.059, 1.0), Color(0.075, 0.545, 0.012, 1.0), 
					Color(1.0, 0.988, 0.0, 1.0), Color(1.0, 0.988, 0.0, 1.0), Color(1.0, 1.0, 1.0, 1.0),
					Color(0.0, 0.871, 1.0, 1.0), Color(0.208, 0.208, 0.208, 1.0), Color(0.208, 0.208, 0.208, 1.0),
					Color(0.208, 0.208, 0.208, 1.0), Color(0.0, 0.659, 1.0, 1.0), Color(0.0, 0.0, 0.0, 1.0), Color(0.0, 0.682, 1.0, 1.0),
					Color(1.0, 0.0, 0.988, 1.0), Color(1.0, 0.847, 0.0, 1.0), Color(1.0, 0.494, 0.0, 1.0), Color(0.357, 0.694, 0.0, 1.0),
					Color(1.0, 0.282, 0.0, 1.0), Color(0.008, 0.945, 0.475, 1.0), Color(0.518, 1.0, 0.0, 1.0), Color(0.0, 0.376, 1.0, 1.0)]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ID: " + str(Globals.id))
	if Globals.id < trail_colors.size():
		self.modulate = trail_colors[Globals.id]
	else:
		self.modulate = Color(1,1,1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
