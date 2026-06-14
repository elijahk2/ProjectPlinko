extends Node2D

var color = 1
var scale_magnitude = 0.1
var animated_bg = null
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.z_index = -101
	color = (color + 1) % 7
	animation.frame = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animation.scale = Vector2(scale_magnitude, scale_magnitude)
	scale_magnitude += 0.05
	if scale_magnitude > 50:
		queue_free()
	
