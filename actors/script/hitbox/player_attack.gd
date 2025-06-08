extends Area2D

func _on_body_entered(body: Node2D) -> void:
	var player = get_player()
	
	# aplica o dano ao inimigo 
	if body.is_in_group("enemies"):
		body.take_damage(player.SWORD_DAMAGE)

# encontra o nó raiz ou o nó que pertence aà classe especificada
func get_player():
	var current_node = self
	while current_node:
		if current_node is Player:
			return current_node
		current_node = current_node.get_parent()
	return null
