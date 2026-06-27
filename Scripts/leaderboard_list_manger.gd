extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_leaderboard_table()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate_leaderboard_table():
	for child in get_children():
		child.queue_free()
	var score_data = Globals.get_leaderboard()
	var leaderboard_length = score_data.size()
	for i in leaderboard_length:
		var new_label = Label.new()
		new_label.text = str(i+1) + ". " + score_data[i]["name"] + " - " + str(score_data[i]["score"])
		new_label.name = "Label" + str(i)
		new_label.add_theme_font_size_override("font_size", 24)
		add_child(new_label)
