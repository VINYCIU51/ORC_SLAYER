extends Node2D

func _ready():
	LevelsGen.parts_to_create = randi_range(LevelsGen.min_level_parts, LevelsGen.max_level_parts)
	LevelsGen.generate_parts("res://scenes/worlds/cave_map/cave_parts/cave_part_",self , $fusion_point.position)
