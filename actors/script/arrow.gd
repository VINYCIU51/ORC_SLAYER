extends CharacterBody2D

const SPEED := 280
const DAMAGE := 1

var direction := 1

func _ready() -> void:
	pass

# Define a direçao da flecha
func set_direction(direct):
	direction = direct
	if direction == 1:
		$sprite.flip_h = false
	else:
		$sprite.flip_h = true

# Faz ela se mover
func _physics_process(delta: float) -> void:
	position.x += SPEED * delta * direction

# Faz ela sumir ao sair da tela
func _on_visibility_screen_exited() -> void:
	queue_free()
