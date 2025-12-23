extends Node2D


func _on_endzone_body_entered(body: RigidBody2D) -> void:
	#Reset to title screen scene when the ball enters CollisionBody at end of drop.
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
