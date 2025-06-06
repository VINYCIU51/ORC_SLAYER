extends CharacterBody2D

@onready var animation := $animation as AnimationPlayer
@onready var wall_detection := $wall_detector as RayCast2D
@onready var floor_detector: RayCast2D = $floor_detector

const SPEED = 50.0

var life := 3
var direction := -1

var is_dead := false
var taked_damage = false
var current_state = "walk"

func _physics_process(delta: float) -> void:
	
	if is_dead: remove_from_group("enemies")
	
	if !is_on_floor():
		velocity += get_gravity() * delta

	if wall_detection.is_colliding() or !floor_detector.is_colliding():
		rotate_sprite(direction)

	velocity.x = direction * SPEED
	
	if taked_damage:
		velocity.x = 0
		if !animation.is_playing():
			taked_damage = false

	set_state()
	move_and_slide()
	
func take_damage(damage: int):
	if is_dead: return
		
	taked_damage = true
	life -= damage
	
	if life <= 0:
		is_dead = true

func rotate_sprite(direct):
	direction = direct * -1
	$sprite.flip_h = direction > 0
	wall_detection.target_position.x = abs(wall_detection.target_position.x) * direction
	floor_detector.target_position.x = abs(wall_detection.target_position.x) * direction

func set_state():
	var new_state = ""
	
	if is_dead:
		new_state = "die"
	elif taked_damage:
		new_state = "hurt"
	elif direction != 0:
		new_state = "walk"
		
	if current_state != new_state:
		animation.play(new_state)
		current_state = new_state

func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		queue_free()
