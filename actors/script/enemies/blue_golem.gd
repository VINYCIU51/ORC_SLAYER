extends CharacterBody2D

@onready var floor_detector: RayCast2D = $floor_detector
@onready var animation: AnimationPlayer = $animation
@onready var player = owner.get_node("player")
@onready var blink_timer: Timer = $blink_timer

const SPEED := 100
const DIST_FOLLOW := 300
const DIST_ATTACK := 40
const DAMAGE := 2

var distance := 0.0
var life := 6
var parry_resistance := 3

var direction := 0
var horizontal_difference := 0
var is_exactly_below := 0
var is_below_player := 0

var is_stuned := false
var has_parryed := false
var is_dead := false
var taked_damage := false
var is_attacking := false
var is_following := false

var current_state := "idle"

func _physics_process(delta: float) -> void:
	
	if is_dead: remove_from_group("enemies")
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if !floor_detector.is_colliding():
		is_following = false
		
	calcule_position()
	
	rotate_sprite()

	if is_exactly_below:
		velocity.x = 0

	is_following = distance <= DIST_FOLLOW and not is_exactly_below

	if distance <= DIST_ATTACK:
		is_attacking = true
		
	if is_following:
		velocity.x = direction * SPEED
		
	if is_attacking:
		velocity.x = 0
		if !animation.is_playing():
			is_attacking = false
			
	if taked_damage:
		velocity.x = 0
		if !animation.is_playing():
			taked_damage = false
			
	if has_parryed:
		velocity.x = 0
			
	if parry_resistance <= 0:
		taked_stun()
	
	set_state()
	move_and_slide()


func set_state():
	var new_state = "idle"

	if is_dead:
		new_state = "die"
	elif taked_damage and !is_attacking:
		new_state = "hurt"
	elif has_parryed:
		new_state = "hurt"
	elif is_stuned:
		new_state = "idle"
	elif is_attacking:
		new_state = "attack"
	elif is_following:
		new_state = "walk"

	if current_state != new_state:
		animation.play(new_state)
		current_state = new_state

func taked_stun():
	is_stuned = true
	await get_tree().create_timer(2.0).timeout
	is_stuned = false
	parry_resistance = 3

func rotate_sprite():
	direction = 1 if $sprite.flip_h == false else -1
	
	$sprite.flip_h = global_position.x > player.global_position.x
	floor_detector.target_position.x = abs(floor_detector.target_position.x) * direction
	$attack_area.position.x = abs($attack_area.position.x) * direction

func take_damage(damage: int):
	if is_dead: return
		
	taked_damage = true
	life -= damage
	blink_timer.start()
	$sprite.self_modulate = Color(100,100,100,1)
	
	if life <= 0:
		is_dead = true

func calcule_position():
	distance = global_position.distance_to(player.global_position)
	horizontal_difference = abs(global_position.x - player.global_position.x)
	is_below_player = global_position.y > player.global_position.y
	is_exactly_below = horizontal_difference < 2 and is_below_player

func _on_attack_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.take_damage(DAMAGE)

func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		queue_free()
	elif anim_name == "hurt" and has_parryed:
		has_parryed = false
		parry_resistance -= 1

func _on_attack_area_area_entered(area: Area2D) -> void:
	if area.name == "parry":
		has_parryed = true

func _on_blink_timer_timeout() -> void:
	$sprite.self_modulate = Color(1,1,1,1)
