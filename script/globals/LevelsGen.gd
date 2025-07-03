extends Node

var max_level_parts := 1
var min_level_parts := 1
var parts_to_create := 0
var repeat := true

func _ready():
	randomize()

# Gera as partes ( seguindo a estrutura de nome: mapa_parte_1 )
func generate_parts(path_base: String, parent: Node, position: Vector2):
	var part: Node

	if parts_to_create >= 1:
		var part_id = randi_range(1, 3)
		part = load_part(path_base + str(part_id) + ".tscn")
		parts_to_create -= 1
	else: 
		repeat = false
		part = load_part(path_base + "boss.tscn") # se as partes acabarem, gera a sala do boss

	add_part_to_scene(part, parent, position)

# repete partes (ex: agua, nuvens, etc)
func repeat_part(path: String, parent: Node, position: Vector2):
	if repeat:
		var part = load_part(path)
		add_part_to_scene(part, parent, position)

# carega a parte
func load_part(path: String) -> Node:
	return load(path).instantiate()

# adiciona à arvore de nós
func add_part_to_scene(part: Node, parent: Node, position: Vector2) -> void:
	part.position = position
	parent.add_child(part)
