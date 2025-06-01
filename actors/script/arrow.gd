extends CharacterBody2D

@onready var wall_collision := $wall_collision as RayCast2D

const SPEED := 280
const DAMAGE := 1
const ARROW_DURATION := 3.5

var direction := 1

# Define a direçao da flecha
func set_direction(direct):
	direction = direct
	$sprite.flip_h = direction < 0
	$wall_collision.target_position.x = $wall_collision.target_position.x * direction

# Faz ela se mover
func _physics_process(delta: float) -> void:
	velocity.x = SPEED * direction
	move_and_slide()
	
	if wall_collision.is_colliding():
		stop_and_disappear()
	
func stop_and_disappear():
		velocity.x = 0
		velocity.y = 0
		
		await get_tree().create_timer(ARROW_DURATION).timeout
		queue_free()

# Faz ela sumir ao sair da tela
func _on_visibility_screen_exited() -> void:
	queue_free()
