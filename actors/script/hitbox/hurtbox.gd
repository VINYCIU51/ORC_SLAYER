extends Area2D

func _on_body_entered(body: Node2D) -> void:
	var player = get_player()
	
	# aplica dano ao player por tocar em um inimigo
	if body.is_in_group("enemies"):
		player.take_damage()

# encontra o nó raiz ou o nó que pertence aà classe especificada
func get_player():
	var current = self
	while current:
		if current is Player:
			return current
		current = current.get_parent()
	return null
