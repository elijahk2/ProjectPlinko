extends VBoxContainer
var user_steam_id
var num_scores = 0
@onready var user_score_label: Label = $"../UserScoreLabel"
@onready var loading_label: Label = $"../LoadingLabel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	user_score_label.hide()
	loading_label.hide()
	user_steam_id = Globals.user_steam_id
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
		if i < 10:
			var new_label = Label.new()
			new_label.text = str(i+1) + ". " + score_data[i]["name"] + " - " + str(score_data[i]["score"])
			new_label.name = "Label" + str(i)
			new_label.add_theme_font_size_override("font_size", 24)
			add_child(new_label)
		if i > 10 and score_data[i]["steam_id"] == user_steam_id:
			user_score_label.text = str(i+1) + ". " + score_data[i]["name"] + " - " + str(score_data[i]["score"])
			user_score_label.show()
			 
