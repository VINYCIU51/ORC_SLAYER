extends Node2D

func _ready():
	global_levels.parts_to_create = randf_range(global_levels.min_level_parts, global_levels.max_level_parts)
	generate_parts()

func generate_parts():
	randomize()
	var part_id = randi_range(1, 2)
	
	if global_levels.parts_to_create >= 1:
		var part = load("res://actors/scenes/worlds/cave_map/cave_parts/cave_part_" + str(part_id) + ".tscn").instantiate()
		part.position = $fusion_point.position
		add_child(part)
		global_levels.parts_to_create -= 1
