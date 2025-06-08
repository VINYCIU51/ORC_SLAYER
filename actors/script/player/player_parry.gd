extends Area2D

func _on_area_entered(area: Area2D) -> void:
	var player = get_player()
	
	# atualiza o player informando que o mesmo acertou o parry
	if area.is_in_group("enemies_attacks"):
		player.has_parried = true
		
# encontra o nó raiz ou o nó que pertence aà classe especificada
func get_player():
	var current = self
	while current:
		if current is Player:
			return current
		current = current.get_parent()
	return null
