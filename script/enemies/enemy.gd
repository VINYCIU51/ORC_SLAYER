class_name Enemy
extends CharacterBody2D

@onready var player = owner.get_node("player")
@onready var animation: AnimationPlayer = $body/animation
@onready var body: Node2D = $body
@onready var sprite: Sprite2D = $body/sprite

var type_patrol := false
var type_follower := false

var speed := 100
var jump_height := -130
var dist_follow := 300
var dist_mellee := 35
var dist_shoot := 200
var dist_spawn := 50

var damage := 1
var life := 3
var max_parry_resistance := 2
var parry_resistance := 0
var num_attacks := 1

var direction := -1
var distance

var should_jump := true

var can_jump := false
var is_stuned := false
var has_parried := false
var is_dead := false
var is_damaged := false
var is_attacking := false
var is_shooting := false
var is_following := false
var has_spawned := true
var is_spawning := false

var current_attack := 1
var current_state := "idle"

func _ready():
	randomize()

func _physics_process(delta: float) -> void:
	update_logic(delta)
	set_state()
	move_and_slide()

func update_logic(delta: float):
	if parry_resistance <= 0:
		parry_resistance = max_parry_resistance
	
	if is_dead:
		velocity.x = 0
		remove_from_group("enemies")
		return
	
	if !is_on_floor():
		velocity += get_gravity() * delta

	if is_following and can_jump:
		velocity.y = jump_height
	
	velocity.x = direction * speed if is_following or type_patrol else 0

	if is_attacking:
		velocity.x = 0
		if !animation.is_playing():
			is_attacking = false
			current_attack = randi_range(1, num_attacks)

	if is_shooting:
		velocity.x = 0
		if !animation.is_playing():
			is_shooting = false

	if is_damaged:
		velocity.x = 0
		if !animation.is_playing():
			is_damaged = false

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
		new_state = "attack_" + str(current_attack)
	elif is_shooting:
		new_state = "shoot"
	elif velocity.x != 0:
		new_state = "walk"
	elif is_spawning:
		new_state = "spawn"

	if current_state != new_state:
		animation.play(new_state)
		current_state = new_state

func take_damage(damage: int):
	if Mobs.apply_damage(self, damage):
		Mobs.hit_blink(sprite)

func flip_sprite():
	if type_patrol:
		direction *= -1
		
	if type_follower:
		direction = 1 if global_position.x < player.global_position.x else -1

	body.scale.x = direction

func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		queue_free()
		
	elif anim_name == "spawn":
		is_spawning = false
		has_spawned = true

	elif anim_name == "parried" and has_parried:
		has_parried = false
		parry_resistance -= 1
		
		if parry_resistance <= 0:
			Mobs.take_stun(self)
