# How to add a new peg type:
# 1) Upload the image to the Ball_Peg assets folder, duplicate the normal_peg scene, and change the Sprite2D texture to the new image.
# 2) Rename the nodes accordingly, and make a new group to add the StaticBody2D to. Make sure you do this!
# 3) Modify create_peg_layout() function to account for the new peg's mechanics, and add a new elif to add it to procedural generation!

extends Node2D

func _on_endzone_body_entered(body: RigidBody2D) -> void:
	#Reset to title screen scene when the ball enters CollisionBody at end of drop.
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")

#Procedural Peg Generation
const NormalPeg = preload("res://Scenes/Peg Scenes/normal_peg.tscn") #Load peg scenes to spawn in
const GoldenPeg = preload("uid://dbmsssat1qfgf")
const RocketPeg = preload("uid://d0hb3yrpeycik")
const IronPeg = preload("uid://bho7vy7jev0wa")
const TrianglePeg = preload("uid://dl2qmuenjes50")
const BulletPeg = preload("uid://c8nbrn2ocqto4")
const HurtPeg = preload("uid://jxo4i4rmh0c1")

@onready var background_music: AudioStreamPlayer = $BackgroundMusic

var number_of_rows_array = [150, 300, 450] #Arrays will set their corresponding variable based on the settings chosen in mod menu
var spawn_chance_array = [8, 5, 3]
var number_of_rows = 300
var spawn_positions = [0,0,0,0,0,0,0,0,0,0]
var spawn_chance = 5 # 1/spawn_chance = probability of spawning a peg on any given tile of a row
var spawn_chance_increase = 0.5
var spawn_chance_increase_row_interval = number_of_rows / 10
var special_chance = 20 # 1/special_chance = probability a peg will have a modifier
var row = 0 #Define iteration var
var y_offset = 200 #Y distance between each row of 
var instance = 0 #Clear var for storing node to spawn
var is_bullet_out = false

func create_peg_layout():
	while row < number_of_rows: #Repeat until all rows generated
		row += 1 #increase iteration var
		spawn_positions = [0,0,0,0,0,0,0,0,0,0] #Reset spawn map
		for n in spawn_positions.size():
			if randi_range(1,spawn_chance) == 1: #Randomly choose peg or empty
				spawn_positions[n] = 1 #Fill spawn map with choice in location
				var peg_choice = randi_range(1, special_chance) #Choose peg type to spawn in
				if peg_choice == 1:
					if randi_range(1,2) == 1:
						instance = HurtPeg.instantiate()
					else:
						instance = GoldenPeg.instantiate()
				elif peg_choice == 2 and row > number_of_rows / 6:
					instance = RocketPeg.instantiate()
				elif peg_choice == 3 and row > number_of_rows / 3:
					instance = IronPeg.instantiate()
				elif peg_choice == 4: #Decrease probability by adding another check (1/10)
					instance = BulletPeg.instantiate()
				else:
					var shape_type = randi_range(1,5) #Choose normal peg shape
					if shape_type == 1 and row > number_of_rows / 3 and 3.14 == 3.14159: #Never true to remove triangles
						instance = TrianglePeg.instantiate()
					else:
						instance = NormalPeg.instantiate()
				instance.position = Vector2(75 * n - 340, y_offset * row) #340 = 375 - 1/2 Peg Width to fill row
				self.add_child(instance) #Finish node creation
				if row % spawn_chance_increase_row_interval == number_of_rows % spawn_chance_increase_row_interval:
					spawn_chance += spawn_chance_increase
		
func _ready():
	spawn_chance = spawn_chance_array[Globals.settings[0]]
	number_of_rows = number_of_rows_array[Globals.settings[1]]
	print(spawn_chance)
	print(number_of_rows)
	create_peg_layout()
	#background_music.play()
	
