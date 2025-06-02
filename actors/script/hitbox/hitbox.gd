extends Area2D


func _on_body_entered(body: Node2D) -> void:
	
	if body.name.begins_with("arrow"):
		body.queue_free()
		owner.take_damage(body.DAMAGE)
