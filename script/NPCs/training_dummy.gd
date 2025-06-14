class_name Training_dummy
extends CharacterBody2D 

@onready var player = owner.get_node("player")
@onready var animation: AnimationPlayer = $animation
@onready var attack_area: Area2D = $attack_area

const DIST_ATTACK := 40
const DAMAGE := 0

var distance := 0.0
var direction := -1

var has_parried := false
var is_damaged := false
var is_attacking := false
var is_active := false

var current_state := "idle"

func _physics_process(delta: float) -> void:
	calculate_position()

	if distance > DIST_ATTACK:
		is_active = false

	if distance <= DIST_ATTACK and is_active:
		is_attacking = true
		
	if is_attacking and current_state == "attack":
		if !animation.is_playing():
			await get_tree().create_timer(0.5).timeout
			is_attacking = false
	
	if has_parried:
		$attack_area/attack.disabled = true
		has_parried = false
	
	set_state()
	move_and_slide()


func set_state():
	var new_state = "idle"

	if is_damaged:
		new_state = "hurt"
	elif is_attacking:
		new_state = "attack"

	if current_state != new_state:
		animation.play(new_state)
		current_state = new_state


func take_damage(damage: int):
	hit_blink()
	is_damaged = true
	is_active = true

func calculate_position():
	distance = global_position.distance_to(player.global_position)
	
func hit_blink():
	$sprite.self_modulate = Color(50,50,50,1)
	await get_tree().create_timer(0.1).timeout
	$sprite.self_modulate = Color(1,1,1,1)


func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_attacking = false
		
	if anim_name == "hurt":
		is_damaged = false
