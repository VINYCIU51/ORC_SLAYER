extends Area2D

@export var player : Player

func _on_area_entered(area: Area2D) -> void:
	
	# atualiza o player informando que o mesmo acertou o parry
	if area.is_in_group("enemies_attacks"):
		player.has_parried = true
		
