class_name Fire_worm
extends CharacterBody2D 

@onready var player = owner.get_node("player")
@onready var animation: AnimationPlayer = $body/animation
@onready var floor_edge: RayCast2D = $body/floor_edge
@onready var step_ahead: RayCast2D = $body/step_ahead

const FIRE_BALL := preload("res://scenes/projectiles/fire_ball.tscn")
const SPEED := 60
const DIST_FOLLOW := 300
const DIST_ATTACK := 200

var distance := 0.0
var life := 6

var direction := 0
var is_below := 0
var at_edge := false
var at_wall := false

var is_dead := false
var is_damaged := false
var is_attacking := false
var is_following := false

var current_state := "idle"

func _physics_process(delta: float) -> void:
	at_edge = !floor_edge.is_colliding()
	at_wall = step_ahead.is_colliding()
	
	if is_dead: remove_from_group("enemies")
	
	if !is_on_floor():
		velocity += get_gravity() * delta
		
	if !is_dead:
		Mobs.distance_to(self, player)
		is_below = Mobs.is_below(self, player)
		rotate_sprite()

	if is_below:
		velocity.x = 0

	is_following = distance <= DIST_FOLLOW and !is_below and !at_edge and !at_wall and !player.is_dead

	if distance <= DIST_ATTACK and !player.is_dead:
		is_attacking = true
		
	velocity.x = direction * SPEED if is_following else 0
		
	if is_attacking:
		velocity.x = 0
		if !animation.is_playing():
			is_attacking = false
			
	if is_damaged:
		velocity.x = 0
		if !animation.is_playing():
			is_damaged = false
	
	set_state()
	move_and_slide()

func set_state():
	var new_state = "idle"

	if is_dead:
		new_state = "die"
	elif is_damaged and !is_attacking:
		new_state = "hurt"
	elif is_attacking:
		new_state = "attack"
	elif is_following and !is_attacking:
		new_state = "walk"

	if current_state != new_state:
		animation.play(new_state)
		current_state = new_state

func rotate_sprite():
	direction = 1 if global_position.x < player.global_position.x else -1
	$body.scale.x = direction

func take_damage(damage):
	if Mobs.apply_damage(self, damage):
		Mobs.hit_blink($body/sprite)

func shoot():
	var shoot_position = $body/shoot_point.global_position
	var direct = $body.scale.x
	Mobs.shoot(FIRE_BALL, self, shoot_position, direct)

func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		queue_free()
