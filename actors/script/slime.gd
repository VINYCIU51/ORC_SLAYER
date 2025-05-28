extends CharacterBody2D

@onready var animation := $animation as AnimationPlayer
@onready var wall_detection := $wall_detector as RayCast2D

var life := 1
var is_dead := false
var taked_damage = false

var direction := -1
const SPEED = 50.0

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if wall_detection.is_colliding():
		direction *= -1
		$sprite.flip_h = false if direction == -1 else true
		wall_detection.target_position.x = direction * abs(wall_detection.target_position.x)
		
	velocity.x = direction * SPEED
	
	if taked_damage:
		velocity.x = 0
		if not animation.is_playing():
			taked_damage = false
		move_and_slide()
		return

	move_and_slide()
	
func take_damage(damage: int):
	taked_damage = true
	life -= damage
	
	if is_dead:
		return
	
	if life > 0:
		animation.play("hurt")
		return
		
	animation.play("die")
	is_dead = true


func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		queue_free()
