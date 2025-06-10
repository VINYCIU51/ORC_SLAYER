class_name Skeleton_axe
extends CharacterBody2D 

@onready var player = owner.get_node("player")
@onready var animation: AnimationPlayer = $body/animation
@onready var floor_edge: RayCast2D = $body/floor_edge
@onready var step_ahead: RayCast2D = $body/step_ahead
@onready var jump_clear: RayCast2D = $body/jump_clear


const SPEED := 80
const JUMP_HEIGHT := -150
const DIST_FOLLOW := 300
const DIST_ATTACK := 25
const DAMAGE := 2

var distance := 0.0
var life := 4
var parry_resistance := 2

var direction := 0
var horizontal_difference := 0
var is_exactly_below := 0
var is_below_player := 0
var at_edge := false
var at_wall := false
var should_jump := false

var is_stuned := false
var has_parried := false
var is_dead := false
var is_damaged := false
var is_attacking := false
var is_following := false

var current_state := "idle"

func _physics_process(delta: float) -> void:
	at_edge = !floor_edge.is_colliding()
	at_wall = step_ahead.is_colliding()
	should_jump = true if at_wall and !jump_clear.is_colliding() else false
	
	if is_dead: remove_from_group("enemies")
	
	if !is_on_floor():
		velocity += get_gravity() * delta
	
	if !is_dead:
		calculate_position()
		rotate_sprite()

	if is_exactly_below:
		velocity.x = 0

	is_following = distance <= DIST_FOLLOW and !is_exactly_below and !at_edge and !jump_clear.is_colliding() and !is_stuned and !player.is_dead

	if is_following and should_jump:
		velocity.y = JUMP_HEIGHT

	if distance <= DIST_ATTACK and !player.is_dead:
		is_attacking = true
		
	velocity.x = direction * SPEED if is_following else 0
		
	if is_attacking:
		velocity.x = 0
		if !animation.is_playing():
			await get_tree().create_timer(0.2).timeout
			is_attacking = false

			
	if is_damaged:
		velocity.x = 0
		if !animation.is_playing():
			is_damaged = false
			
	if has_parried:
		velocity.x = 0
		$body/attack_area/attack.disabled = true
			
	if parry_resistance <= 0:
		take_stun()
	
	set_state()
	move_and_slide()


func set_state():
	var new_state = "idle"

	if is_dead:
		new_state = "die"
	elif is_damaged and !is_attacking:
		new_state = "hurt"
	elif has_parried:
		new_state = "parried"
	elif is_stuned:
		new_state = "idle"
	elif is_attacking:
		new_state = "attack"
	elif is_following:
		new_state = "walk"

	if current_state != new_state:
		animation.play(new_state)
		current_state = new_state

func take_stun():
	is_stuned = true
	await get_tree().create_timer(2.0).timeout
	is_stuned = false
	parry_resistance = 1

func rotate_sprite():
	direction = 1 if global_position.x < player.global_position.x else -1
	$body.scale.x = direction
	$collision.position.x = direction * -3

func take_damage(damage: int):
	if is_dead or damage == 0: return
		
	hit_blink()
	is_damaged = true
	life -= damage
	
	if life <= 0:
		is_dead = true

func calculate_position():
	distance = global_position.distance_to(player.global_position)
	horizontal_difference = abs(global_position.x - player.global_position.x)
	is_below_player = global_position.y > player.global_position.y
	is_exactly_below = horizontal_difference < 2 and is_below_player
	
func hit_blink():
	$body/sprite.self_modulate = Color(50,50,50,1)
	await get_tree().create_timer(0.1).timeout
	$body/sprite.self_modulate = Color(1,1,1,1)

func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		queue_free()
	elif anim_name == "parried" and has_parried:
		has_parried = false
		parry_resistance -= 1
