extends Node2D

func _on_endzone_body_entered(body: RigidBody2D) -> void:
	#Reset to title screen scene when the ball enters CollisionBody at end of drop.
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")

#Procedural Peg Generation
const NormalPeg = preload("res://Scenes/peg.tscn") #Load NormalPeg to spawn in

var number_of_rows = 100
var spawn_positions = [0,0,0,0,0,0,0,0,0,0]
var spawn_chance = 10 # 1/spawn_chance = probability of spawning a peg on any given tile of a row
var row = 0 #Define iteration var
var y_offset = 200 #Y distance between each row of 

func create_peg_layout():
	while row < number_of_rows:
		row += 1
		spawn_positions = [0,0,0,0,0,0,0,0,0,0]
		for n in spawn_positions.size():
			if randi_range(1,spawn_chance) == 1:
				spawn_positions[n] = 1
				var instance = NormalPeg.instantiate()
				instance.position = Vector2(75 * n - 340, y_offset * row) #340 = 375 - 1/2 Peg Width to fill row
				self.add_child(instance)
		
func _ready():
	create_peg_layout()
