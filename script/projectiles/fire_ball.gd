class_name Fire_ball
extends CharacterBody2D

@onready var wall_collision := $body/wall_collision as RayCast2D
@onready var wall_collision_2: RayCast2D = $body/wall_collision2
@onready var animation: AnimationPlayer = $body/animation

const SPEED := 350

var has_collided := false
var damage := 1
var direction := -1

var current_state = "move"

func _physics_process(_delta):
	
	if !has_collided:
		velocity.x = SPEED * direction
		move_and_slide()
		
	if wall_collision.is_colliding() or wall_collision_2.is_colliding():
		has_collided = true
	
	set_state()

func set_state():
	var new_state = "move"

	if has_collided:
		new_state = "explode"

	if current_state != new_state:
		animation.play(new_state)
		current_state = new_state

# ajusta a direcao da bola de fogo
func set_direction(dir):
	direction = dir
	$body.scale.x = sign(direction)

# faz a bola de fogo desaparecer ao sair da tela
func _on_visibility_screen_exited() -> void:
	queue_free()

func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explode":
		queue_free()
