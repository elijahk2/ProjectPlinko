extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Steam.steamInit()
	var steam_running = Steam.isSteamRunning()
	if !steam_running:
		print("Steam is NOT running, please run steam for integration to work.")
		return
	
	var user_id = Steam.getSteamID()
	var name = Steam.getFriendPersonaName(user_id)
	print("Your Steam name is " + name)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
