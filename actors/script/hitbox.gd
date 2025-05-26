extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.take_damage()
	
	if body.name == "arrow":
		body.queue_free()
		owner.animation.play("die")
