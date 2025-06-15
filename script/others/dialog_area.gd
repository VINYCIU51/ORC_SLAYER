extends Area2D

@onready var label: Label = $Label
var typing := false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		typing = true
		
		for i in range(label.get_total_character_count()):
			if !typing:
				label.visible_characters = 0
				break
			await get_tree().create_timer(0.05).timeout
			label.visible_characters += 1

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		typing = false
		label.visible_characters = 0
