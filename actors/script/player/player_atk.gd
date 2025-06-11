extends Area2D

@export var player : Player

func _on_body_entered(body: Node2D) -> void:
	
	# aplica o dano ao inimigo 
	if body.is_in_group("enemies"):
		body.take_damage(player.SWORD_DAMAGE)
