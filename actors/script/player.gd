extends CharacterBody2D

@onready var animation := $animation as AnimationPlayer
@onready var invencible_timer := $invencible_timer
@onready var blink_timer := $blink_timer

const ARROW := preload("res://actors/scenes/projectiles/arrow.tscn")
const SPEED := 250
const DEATH_HEIGHT := 1000
const SWORD_DAMAGE := 2

var life := 3
var is_dead := false

var jump_height := 80
var time_to_top_height := 0.5
var jump_velocity
var gravity
var fall_gravity

var direction

var is_invencible := false
var taked_damage := false
var is_jumping := false
var is_attacking := false

# DEFINE AS VARIAVEIS DE SALTO NO INICIO
func _ready():
	jump_velocity = (jump_height*2) / time_to_top_height
	gravity = (jump_height * 2) / pow(time_to_top_height,2)
	fall_gravity = gravity * 2

func _physics_process(delta):
	# Reinicia caso o boneco caia no limbo
	if global_position.y > DEATH_HEIGHT:
		fall_out()

	if is_dead:
		if animation.is_playing():
			velocity.x = 0
		return

	# Atualiza direção
	direction = Input.get_axis("move_left", "move_right")
	if not taked_damage:
		velocity.x = direction * SPEED
	
	# Inverte sprite conforme direção
	if direction != 0 and not is_attacking:
		rotate_player(direction)

	# Pulo
	if Input.is_action_pressed("jump") and is_on_floor() and not is_attacking:
		velocity.y = -jump_velocity
		animation.play("jump")
		is_jumping = true

	# Aplica gravidade do pulo
	if not is_on_floor():
		if Input.is_action_pressed("jump") and velocity.y < 0:
			velocity.y += gravity * delta
		else:
			velocity.y += fall_gravity * delta
	
	# Tiro de flecha no ar
	if not is_on_floor() and not is_attacking and Input.is_action_just_pressed("right_click"):
		is_attacking = true
		shoot_arrow(sign($arrow_point.position.x), 0.3)
		animation.play("air_arrow")
		
	# Impede interrupções de Ataques
	if is_attacking:
		if is_on_floor():
			velocity.x = 0
			
		if not animation.is_playing():
			is_attacking = false
		move_and_slide()
		return

	# Impede interrupções de Saltos
	if is_jumping:
		if not animation.is_playing() and is_on_floor():
			is_jumping = false
		move_and_slide()
		return
		
	# Impede interrupções da animaçao de dano
	if taked_damage:
		knockback()
		if not animation.is_playing():
			taked_damage = false
		move_and_slide()
		return
		
	# Define animação com prioridade
	if direction != 0:
		animation.play("walk")
	else:
		animation.play("idle")

	# Ativa animações de Ataques
	if is_on_floor() and Input.is_action_just_pressed("left_click"):
		is_attacking = true
		animation.play("atack")
		
	if is_on_floor() and Input.is_action_just_pressed("right_click"):
		is_attacking = true
		shoot_arrow(sign($arrow_point.position.x))
		animation.play("arrow")

		
	move_and_slide()

# Função para reiniciar após a morte
func fall_out():
	get_tree().reload_current_scene()
	
# Funçao que gerencia o dano e a morte do personagem
func take_damage():
	if is_invencible or is_dead:
		return
		
	taked_damage = true
	invencible_mode()
	life -= 1
	
	if life > 0:
		animation.play("hurt")
		return
		
	animation.play("die")
	is_dead = true
	
func invencible_mode():
	is_invencible = true
	blink_timer.start()
	invencible_timer.start()

# Função que atira as flechas
func shoot_arrow(direct, time := 0.5):
	await get_tree().create_timer(time).timeout # Time para sincronizar com a animação
	
	var arrow_instance = ARROW.instantiate() # Instância a flecha
	add_sibling(arrow_instance, true) # Gera ela com base no mundo
	arrow_instance.set_direction(direct) # Define a direção
	arrow_instance.position = $arrow_point.global_position # Inicia no ponto definido (arco)

func rotate_player(direction):
	$sprite.flip_h = direction < 0
	if sign($arrow_point.position.x) != direction:
		$arrow_point.position.x *= -1
		$melee.position.x *= -1
		
func knockback():
	var knock_direction = 1 if $sprite.flip_h else -1
	velocity.x = knock_direction * 100


func _on_melee_body_entered(body: Node2D):
	if body.is_in_group("enemies"):
		body.take_damage(SWORD_DAMAGE)


func _on_invencible_timer_timeout() -> void:
	is_invencible = false
	blink_timer.stop()
	$sprite.visible = true


func _on_blink_timer_timeout() -> void:
	$sprite.visible = !$sprite.visible 
