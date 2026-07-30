extends Node2D
var color = 1
var scale_magnitude = 0.1
var scale_speed = 8
var animated_bg = null
var limit = 50
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	scale_speed = Globals.color_shift_speed
	self.z_index = -101
	color = (color) % 7
	animation.frame = color

func _process(delta: float) -> void:
	animation.scale = Vector2(scale_magnitude, scale_magnitude)
	scale_magnitude += scale_speed * delta
	if scale_magnitude > limit:
		if animated_bg:
			animated_bg.frame = color + 1
		queue_free()
