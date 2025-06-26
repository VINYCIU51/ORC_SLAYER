extends Area2D
 
func _on_body_entered(body: Node2D) -> void:
	if body.name.begins_with("arrow"):
		owner.take_damage(body.damage)
		body.queue_free()
