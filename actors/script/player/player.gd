class_name Player
extends CharacterBody2D 

@onready var animation := $body/animation
@onready var invincible_timer := $invincible_timer
@onready var blink_timer := $blink_timer
@onready var sprite := $body/sprite

const ARROW := preload("res://actors/scenes/projectiles/arrow.tscn")
const SPEED := 200
const DEATH_HEIGHT := 500
const SWORD_DAMAGE := 2

var life := 3
var is_dead := false

var jump_height := 80
var time_to_top_height := 0.5
var jump_velocity
var gravity
var fall_gravity

var direction = 0.0

var is_invincible := false
var took_damage := false
var is_attacking := false
var is_shooting := false
var is_air_shooting := false
var has_parried := false
var is_blocking := false
var current_state := "idle"

func _ready():
	jump_velocity = (jump_height * 2) / time_to_top_height
	gravity = (jump_height * 2) / pow(time_to_top_height, 2)
	fall_gravity = gravity * 2

func _physics_process(delta):
	if global_position.y > DEATH_HEIGHT:
		fall_out()

	if is_dead:
		velocity.x = 0
		set_state()
		return

	direction = Input.get_axis("move_left", "move_right")

	if !took_damage:
		velocity.x = direction * SPEED

	if direction != 0 and !is_attacking and !is_shooting and !is_air_shooting and !is_blocking:
		flip_sprite(direction)

	# Pulo
	if Input.is_action_just_pressed("jump") and is_on_floor() and !is_attacking and !is_blocking:
		velocity.y = -jump_velocity

	# Gravidade
	if !is_on_floor():
		if Input.is_action_pressed("jump") and velocity.y < 0:
			velocity.y += gravity * delta
		else:
			velocity.y += fall_gravity * delta

	# Tiro no ar
	if !is_on_floor() and Input.is_action_just_pressed("interact") and !is_attacking and !is_air_shooting:
		is_air_shooting = true

	# Tiro no chão
	if is_on_floor() and Input.is_action_just_pressed("interact") and !is_shooting and !is_attacking and !is_blocking:
		is_shooting = true

	# Ataque corpo-a-corpo
	if is_on_floor() and Input.is_action_just_pressed("left_click") and !is_attacking and !is_shooting and !is_blocking:
		is_attacking = true

	if is_on_floor() and Input.is_action_just_pressed("right_click") and !is_attacking and !is_shooting and !is_air_shooting:
		is_blocking = true
		
	set_state()
	if is_blocking:
		velocity.x = 0
		if !animation.is_playing() or current_state != "parry": 
			$parry/parry_area.disabled = true
			is_blocking = false

	# Verifica se terminou o ataque
	if is_attacking:
		velocity.x = 0
		if !animation.is_playing(): is_attacking = false
	
	# Verifica o fim do tiro
	if is_shooting:
		velocity.x = 0
		if !animation.is_playing(): is_shooting = false
	
	# Verifica o fim do tiro aéreo
	if is_air_shooting:
		if !animation.is_playing(): is_air_shooting = false

	# Verifica fim de dano
	if took_damage:
		knockback()
		if !animation.is_playing(): took_damage = false

	move_and_slide()

func set_state():
	var new_state = "idle"

	if is_dead:
		new_state = "die"
	elif took_damage:
		new_state = "hurt"
	elif is_attacking:
		new_state = "attack"
	elif is_shooting:
		new_state = "arrow"
	elif is_air_shooting:
		new_state = "air_arrow"
	elif is_blocking:
		new_state = "parry"
	elif !is_on_floor():
		new_state = "jump"
	elif direction != 0:
		new_state = "walk"

	if current_state != new_state:
		animation.play(new_state)
		current_state = new_state

func fall_out():
	get_tree().reload_current_scene()

func take_damage(damage := 1):
	if is_invincible or is_dead or has_parried: return

	took_damage = true
	invincible_mode()
	life -= damage

	if life <= 0: is_dead = true

func shoot_arrow():
	var arrow_instance = ARROW.instantiate()
	add_sibling(arrow_instance, true)
	
	var direct = sign($body.scale.x)
	arrow_instance.set_direction(direct)
	arrow_instance.position = $body/arrow_point.global_position

func flip_sprite(dir):
	$body.scale.x = sign(dir)

func knockback():
	var knock_direction = -sign($body.scale.x)
	velocity.x = knock_direction * 100

func invincible_mode():
	is_invincible = true
	set_collision_mask_value(3,false)
	blink_timer.start()
	invincible_timer.start()

func _on_invincible_timer_timeout() -> void:
	is_invincible = false
	set_collision_mask_value(3,true)
	blink_timer.stop()
	sprite.visible = true

func _on_blink_timer_timeout() -> void:
	sprite.visible = !sprite.visible
