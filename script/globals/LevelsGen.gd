extends Node

var max_level_parts := 8
var min_level_parts := 7
var parts_to_create := 0

func generate_parts(path: String, parent : Node ,position : Vector2):
	randomize()
	var part_id = randi_range(1, 2)
	
	if parts_to_create >= 1:
		var part = load(path + str(part_id) + ".tscn").instantiate()
		part.position = position
		parent.add_child(part)
		parts_to_create -= 1

func repeat_part (path: String, parent : Node ,position : Vector2):
	var part = load(path).instantiate()
	part.position = position
	parent.add_child(part)
