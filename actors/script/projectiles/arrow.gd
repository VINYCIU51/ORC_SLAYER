class_name Arrow
extends CharacterBody2D

@onready var wall_collision := $wall_collision as RayCast2D

const SPEED := 300
const ARROW_DURATION := 3.5

var has_collided := false
var damage := 1
var direction := 1


func _physics_process(delta: float) -> void:
	if !has_collided:
		velocity.x = SPEED * direction
		move_and_slide()
		
		if wall_collision.is_colliding():
			has_collided = true
			damage = 0
			stop_and_disappear()

# faz a flecha parar e desaparecer depois de um tempo ao colidir com a parede
func stop_and_disappear():
	velocity.x = 0
	velocity.y = 0
		
	await get_tree().create_timer(ARROW_DURATION).timeout
	queue_free()

# ajusta a direcao da flecha
func set_direction(dir):
	direction = dir
	$sprite.flip_h = direction < 0
	$wall_collision.target_position.x = $wall_collision.target_position.x * direction

# faz a flecha desaparecer ao sair da tela
func _on_visibility_screen_exited() -> void:
	queue_free()
