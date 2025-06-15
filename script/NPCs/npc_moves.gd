extends CharacterBody2D

@onready var animation := $body/animation as AnimationPlayer

const SPEED = 40.0

var direction := 1
var move_cooldow := 1.0
var current_state = "idle"

func _physics_process(delta: float) -> void:
	move_cooldow -= delta
	
	if move_cooldow <= 0:
		randow_move()

	if !is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = direction * SPEED

	flip_sprite()
	set_state()
	move_and_slide()

func flip_sprite():
	if direction != 0:
		$body.scale.x = direction

func set_state():
	var new_state = "idle"
	
	if direction == 0:
		new_state = "idle"
	if direction != 0:
		new_state = "walk"
		
	if current_state != new_state:
		animation.play(new_state)
		current_state = new_state

func randow_move():
	direction = randi_range(-1,1)
	move_cooldow = randi_range(1.0, 2.0)
