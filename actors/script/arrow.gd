extends CharacterBody2D

const SPEED := 280

var direction := 1

func _ready() -> void:
	pass

# DEFINE A DIREÇAO DA FLECHA
func set_direction(direct):
	direction = direct
	if direction == 1:
		$sprite.flip_h = false
	else:
		$sprite.flip_h = true

# FAZ ELA SE MOVER
func _physics_process(delta: float) -> void:
	position.x += SPEED * delta * direction

# FAZ ELA SUMIR AO SAIR DA TELA
func _on_visibility_screen_exited() -> void:
	queue_free()
