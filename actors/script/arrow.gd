extends CharacterBody2D

@onready var wall_collision := $wall_collision as RayCast2D

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
	velocity.x = SPEED * direction
	
	if wall_collision.is_colliding():
		velocity.x = 0
		velocity.y = 0
		return
	
	move_and_slide()

# Faz ela sumir ao sair da tela
func _on_visibility_screen_exited() -> void:
	queue_free()
