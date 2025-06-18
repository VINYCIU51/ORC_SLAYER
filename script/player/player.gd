class_name Player
extends CharacterBody2D 

@onready var animation := $body/animation
@onready var invincible_timer := $invincible_timer
@onready var blink_timer := $blink_timer
@onready var parry_area:= $parry/parry_area
@onready var attack_area:= $body/sword_attack/attack_area

const ARROW := preload("res://scenes/projectiles/arrow.tscn")
const SPEED := 200
const DEATH_HEIGHT := 500
const SWORD_DAMAGE := 2

var life := 5

var jump_height := 80
var time_to_top_height := 0.5
var jump_velocity
var gravity
var fall_gravity

var direction = 0.0

var is_dead := false
var is_invincible := false
var is_damaged := false
var is_attacking := false
var is_shooting := false
var is_air_shooting := false
var has_parried := false
var is_blocking := false
var current_state := "idle"

func _ready():
	add_to_group("player")
	jump_velocity = (jump_height * 2) / time_to_top_height
	gravity = (jump_height * 2) / pow(time_to_top_height, 2)
	fall_gravity = gravity * 2

func _physics_process(delta):
	if global_position.y > DEATH_HEIGHT:
		fall_off_screen()

	# Bloqueios para impedir açoes pós morte
	if is_dead:
		velocity.x = 0
		velocity.y += fall_gravity * delta
		move_and_slide()
		set_state()
		return

	# Define a direção com base no input de movimento
	direction = Input.get_axis("move_left", "move_right")

	# Permite o movimento do player se ele nao estiver recebendo dano
	if !is_damaged:
		velocity.x = direction * SPEED

	# Verifica a direcao do personagem para efetuar o flip de sprite
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

	# Efetua bloqueio / parry
	if is_on_floor() and Input.is_action_just_pressed("right_click") and !is_attacking and !is_shooting and !is_air_shooting:
		is_blocking = true
		
	set_state()
	
	# Verifica o fim da animacao de bloqueio comum
	if is_blocking:
		velocity.x = 0
		if !animation.is_playing() or current_state != "parry": 
			parry_area.disabled = true
			is_blocking = false

	# Verifica o fim da animacao de parry bem sucedido (com faiscas)
	if has_parried:
		velocity.x = 0
		if !animation.is_playing() or current_state != "successful_parry": 
			has_parried = false

	# Verifica se terminou o ataque
	if is_attacking:
		velocity.x = 0
		if !animation.is_playing() or current_state != "attack": 
			attack_area.disabled = true
			is_attacking = false
	
	# Verifica o fim do tiro
	if is_shooting:
		velocity.x = 0
		if !animation.is_playing(): is_shooting = false
	
	# Verifica o fim do tiro aéreo
	if is_air_shooting:
		if !animation.is_playing(): is_air_shooting = false

	# Verifica fim de dano
	if is_damaged:
		if !animation.is_playing(): is_damaged = false

	move_and_slide()

# Gerencia as animacoes do personagem
func set_state():
	var new_state = "idle"

	if is_dead:
		new_state = "die"
	elif is_damaged:
		new_state = "hurt"
	elif is_attacking:
		new_state = "attack"
	elif is_shooting:
		new_state = "shoot"
	elif is_air_shooting:
		new_state = "air_shoot"
	elif is_blocking and !has_parried:
		new_state = "parry"
	elif has_parried:
		new_state = "successful_parry"
	elif !is_on_floor():
		new_state = "jump"
	elif direction != 0:
		new_state = "walk"

	if current_state != new_state:
		animation.play(new_state)
		current_state = new_state

# Faz ele reaparecer ao cair dos limites da tela
func fall_off_screen():
	get_tree().reload_current_scene()

# Efetua as verificaçoes e ativaçoes ao tomar um hit
func take_damage(damage : int, enemie_position := Vector2.ZERO):
	if is_invincible or is_dead or has_parried: return

	is_damaged = true
	knockback(enemie_position)
	enable_invincibility()
	life -= damage

	if life <= 0: is_dead = true

# Efetua o disparo da flecha
func shoot():
	var shoot_position = $body/arrow_point.global_position
	var direct = $body.scale.x
	Mobs.shoot(ARROW, self, shoot_position, direct)

# Inverte a direcao do sprite do personagem
func flip_sprite(dir):
	$body.scale.x = sign(dir)

# Faz o personagem ser lançado na direcao oposta do inimigo que lhe inferiu dano
func knockback(dir):
	var knock_direction = sign(global_position.x - dir.x)
	velocity.x = knock_direction * 100

# Ativa o modo de invencibilidade permitindo o personagem andar sem tomar dano por um periodo
func enable_invincibility():
	is_invincible = true
	set_collision_mask_value(3,false)
	blink_timer.start()
	invincible_timer.start()

# Faz as desativaçoes de invencibilidade ao fim do tempo
func _on_invincible_timer_timeout() -> void:
	is_invincible = false
	set_collision_mask_value(3,true)
	blink_timer.stop()
	$body/sprite.visible = true

# Faz o efeito de "piscar" do personagem
func _on_blink_timer_timeout() -> void:
	$body/sprite.visible = !$body/sprite.visible
