extends Node

var max_level_parts := 2
var min_level_parts := 2
var parts_to_create := 0
var repeat := true
var part_id
var last_id := 0

func _ready():
	randomize()

# Gera as partes ( seguindo a estrutura de nome: mapa_parte_1 )
func generate_parts(path_base: String, parent: Node, position: Vector2):
	var part: Node

	if parts_to_create >= 1:
		part_id = randi_range(1, 3)
		
		validate_part()
		
		part = load_part(path_base + str(part_id) + ".tscn")
		parts_to_create -= 1
		last_id = part_id
	else: 
		repeat = false
		part = load_part(path_base + "boss.tscn") # se as partes acabarem, gera a sala do boss

	add_part_to_scene(part, parent, position)

# impede que se repitam duas partes iguais uma atras da outra
func validate_part():
	while part_id == last_id:
		part_id = randi_range(1, 3)
	last_id = part_id

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
