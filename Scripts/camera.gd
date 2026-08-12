extends Camera2D

var is_locked: bool = false

func _process(_delta: float) -> void:
	if Globals.dead and not is_locked:
		lock_position()

func lock_position() -> void:
	is_locked = true
	var current_global_pos = global_position
	top_level = true
	global_position = current_global_pos
	var viewport_height: float = get_viewport_rect().size.y
	Globals.cutoff_y = global_position.y + 1500
