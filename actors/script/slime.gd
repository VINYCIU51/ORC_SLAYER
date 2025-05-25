extends CharacterBody2D

@onready var wall_detection := $wall_detector as RayCast2D
var direction := -1
const SPEED = 50.0

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if wall_detection.is_colliding():
		direction *= -1
		$sprite.flip_h = false if direction == -1 else true
		wall_detection.target_position.x = direction * abs(wall_detection.target_position.x)
		
	$animation.play("walk")
	velocity.x = direction * SPEED

	move_and_slide()
