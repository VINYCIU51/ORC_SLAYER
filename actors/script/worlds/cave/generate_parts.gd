extends Node2D

func _ready():
	await get_tree().create_timer(0.5).timeout
	generate_parts()

func generate_parts():
	randomize()
	var part_id = randi_range(1, 2)
	
	if global_levels.parts_to_create >= 1:
		var part = load("res://actors/scenes/worlds/cave_map/cave_parts/cave_part_" + str(part_id) + ".tscn").instantiate()
		part.position = $fusion_point.position
		add_child(part)
		global_levels.parts_to_create -= 1
