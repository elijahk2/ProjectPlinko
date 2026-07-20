extends RigidBody2D

var frame_count = 4 # Number of frames excluding the stars
var star_chance = 1000
var is_dying = 0
@onready var ball_frames_node: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Globals.title_balls_toggle:
		self.hide()
	if randi_range(1, star_chance) != 1:
		ball_frames_node.frame = randi_range(0, frame_count)
	elif Globals.current_star == 0:
		if randi_range(1, 100) == 1:
			Globals.current_star = 3
			ball_frames_node.frame = frame_count + 3
		elif randi_range(1, 10) == 1:
			Globals.current_star = 2
			ball_frames_node.frame = frame_count + 2
		else:
			Globals.current_star = 1
			ball_frames_node.frame = frame_count + 1
	if ball_frames_node.frame <= frame_count:
		ball_frames_node.scale = Vector2(0.044, 0.044)
		hitbox.scale = Vector2(1, 1)
	else:
		ball_frames_node.scale = Vector2(0.1,0.1)
		hitbox.scale = Vector2(2.27,2.27)
	self.apply_central_impulse(Vector2(randi_range(-10, 10), 0))

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("title_bound"):
		self.apply_central_impulse(Vector2(0, -400))
		#Globals.play_bounce_sfx()

func _physics_process(delta: float) -> void:
	if self.position.y > 780:
		Globals.change_ball_num(-1)
		queue_free()
		return
	if Globals.current_star > 0 and Input.is_action_just_pressed("push"):
		if self.ball_frames_node.frame > frame_count:
			self.apply_central_impulse(Vector2(randi_range(-200, 200), -1500))
			#Maybe get a sound effect for this??
			self.is_dying = 1
	if self.is_dying == 1:
		modulate.a -= delta
		if modulate.a <= 0:
			Globals.change_ball_num(-1)
			queue_free()
			
