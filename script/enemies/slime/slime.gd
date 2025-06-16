class_name Slime
extends CharacterBody2D

@onready var animation := $body/animation as AnimationPlayer
@onready var wall_detection := $body/wall_detector as RayCast2D
@onready var floor_detector: RayCast2D = $body/floor_detector

const SPEED = 50.0

var life := 3
var direction := -1

var is_dead := false
var is_damaged = false
var current_state = "walk"

func _physics_process(delta: float) -> void:
	
	if is_dead: remove_from_group("enemies")
	
	if !is_on_floor():
		velocity += get_gravity() * delta

	if wall_detection.is_colliding() or !floor_detector.is_colliding():
		flip_sprite()

	velocity.x = direction * SPEED
	
	if is_damaged:
		velocity.x = 0
		if !animation.is_playing():
			is_damaged = false

	set_state()
	move_and_slide()
	
func take_damage(damage : int):
	if Mobs.apply_damage(self, damage):
		Mobs.hit_blink($body/sprite)

func flip_sprite():
	direction *= -1
	$body.scale.x = direction

func set_state():
	var new_state = ""
	
	if is_dead:
		new_state = "die"
	elif is_damaged:
		new_state = "hurt"
	elif direction != 0:
		new_state = "walk"
		
	if current_state != new_state:
		animation.play(new_state)
		current_state = new_state

func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		queue_free()
