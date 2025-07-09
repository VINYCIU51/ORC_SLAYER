extends Area2D

@export var label: Label
@onready var sound: AudioStreamPlayer2D = $dialog_sound
var typing := false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		sound.play()
		typing = true
		body.velocity.x = 10
		
	for i in range(label.get_total_character_count()):
		
		if !typing: # certifica de limpar todos oa caracteres ao sair da area (por conta do for com delay)
			label.visible_characters = 0
			break
		
		# Digita cada letra com um pequeno delay
		await get_tree().create_timer(0.05).timeout
		label.visible_characters += 1
		
		# Para o som se o texto foi digitado por completo
		if label.visible_characters == label.get_total_character_count():
			sound.stop()
			typing = false
			break

# Para o som e limpa o texto ao sair da área
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		sound.stop()
		typing = false
		label.visible_characters = 0
