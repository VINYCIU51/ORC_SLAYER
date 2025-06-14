extends Area2D

@export var player : Player

func _on_body_entered(body: Node2D) -> void:
	
	# aplica dano ao player por tocar em um inimigo
	if body.is_in_group("enemies") or body.is_in_group("enemies_projectiles"):
		if body.name == "training_dummy": return
		
		player.take_damage(1, body.global_position)
