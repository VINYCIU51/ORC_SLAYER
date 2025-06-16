extends Node2D

func _ready():
	await get_tree().create_timer(0.5).timeout
	LevelsGen.generate_parts("res://scenes/worlds/cave_map/cave_parts/cave_part_",self , $fusion_point.position)
