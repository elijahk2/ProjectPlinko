extends RigidBody2D

var frame_count = 4 #Number of frames
@onready var ball_frames_node: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball_frames_node.frame = randi_range(0, frame_count)
	self.apply_central_impulse(Vector2(randi_range(-10,10), 0))
	pass # Replace with function body.

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("title_bound"):
		self.apply_central_impulse(Vector2(0, -400))
		#Globals.play_bounce_sfx()

func _process(delta: float) -> void:
	if self.position.y > 780:
		Globals.change_ball_num(-1)
		print(Globals.num_balls)
		queue_free()
	
