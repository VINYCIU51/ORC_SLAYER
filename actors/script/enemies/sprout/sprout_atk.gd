extends Area2D

func _on_body_entered(body: Node2D) -> void:
	var mob = get_mob()
	
	# se o player tiver entrado em contato com a area, ele toma o dano referente á força do mob
	if body.name == "player":
		body.take_damage(mob.DAMAGE)
		

func _on_area_entered(area: Area2D) -> void:
	var mob = get_mob()
	
	# se  player estiver com o parry ativo no momento do impacto, o mob recebe um parry
	if area.name == "parry":
		mob.has_parried = true


# encontra o nó raiz ou o nó que pertence à classe especificada
func get_mob():
	var current_node = self
	while current_node:
		if current_node is Sprout:
			return current_node
		current_node = current_node.get_parent()
	return null
