extends Area2D

func _on_body_entered(body: Node2D) -> void:
	var player = get_player()
	
	# aplica o dano ao inimigo 
	if body.is_in_group("enemies"):
		body.take_damage(player.SWORD_DAMAGE)

# encontra o nó raiz ou o nó que pertence aà classe especificada
func get_player():
	var current = self
	while current:
		if current is Player:
			return current
		current = current.get_parent()
	return null
