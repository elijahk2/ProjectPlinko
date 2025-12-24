extends Node2D

func _on_endzone_body_entered(body: RigidBody2D) -> void:
	#Reset to title screen scene when the ball enters CollisionBody at end of drop.
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")

#Procedural Peg Generation
const NormalPeg = preload("res://Scenes/Peg Scenes/normal_peg.tscn") #Load NormalPeg to spawn in
const GoldenPeg = preload("uid://dbmsssat1qfgf")


var number_of_rows = 300
var spawn_positions = [0,0,0,0,0,0,0,0,0,0]
var spawn_chance = 5 # 1/spawn_chance = probability of spawning a peg on any given tile of a row
var row = 0 #Define iteration var
var y_offset = 200 #Y distance between each row of 
var instance = 0 #Clear var for storing node to spawn

func create_peg_layout():
	while row < number_of_rows: #Repeat until all rows generated
		row += 1 #increase iteration var
		spawn_positions = [0,0,0,0,0,0,0,0,0,0] #Reset spawn map
		for n in spawn_positions.size():
			if randi_range(1,spawn_chance) == 1: #Randomly choose peg or empty
				spawn_positions[n] = 1 #Fill spawn map with choice in location
				if randi_range(1,10) == 1:
					instance = GoldenPeg.instantiate()
				else:
					instance = NormalPeg.instantiate() #Create a new peg
				instance.position = Vector2(75 * n - 340, y_offset * row) #340 = 375 - 1/2 Peg Width to fill row
				self.add_child(instance) #Finish node creation
		
func _ready():
	create_peg_layout()
