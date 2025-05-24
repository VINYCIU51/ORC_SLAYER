extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -400.0
const DEATH_HEIGHT = 1400.0

@onready var animation: AnimationPlayer = $animation
@onready var sprite: Sprite2D = $sprite

var direction = Vector2.ZERO
var is_attacking = false

func _physics_process(delta):
	
# MORRE CASO CAIA NESTA AREA
	if global_position.y > DEATH_HEIGHT:
		die()
	
	if is_attacking:
		# IMPEDE QUE OUTRAS ANIMAÇÕES ATRAPALHEM AS DE ATAQUE
		if not animation.is_playing():
			is_attacking = false
		move_and_slide()
		return
	
	# APLICA A GRAVIDADE
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	else:
		if velocity.x == 0: 
			animation.play("idle")
	
# EFETUA O SALTO
	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.play("jump")    

# EFETUA O MOVIMENTO DO PERSONAGEM
	if Input.is_key_pressed(KEY_D):
		direction.x = 1 
		sprite.flip_h = false
	elif Input.is_key_pressed(KEY_A): 
		direction.x = -1
		sprite.flip_h = true
	else:
		direction.x = 0

# MOVIMENTO
	velocity.x = direction.x * SPEED

# APLICA A ANIMAÇÃO DE CAMINHAR
	if is_on_floor() and direction.x != 0:
		animation.play("walk")

# EFETUA OS ATAQUES DE ESPADA E FLECHA
	if is_on_floor() and Input.is_action_just_pressed("left_click"):
		velocity.x = 0
		is_attacking = true
		animation.play("atack")
		
	if is_on_floor() and Input.is_action_just_pressed("right_click"):
		velocity.x = 0
		is_attacking = true
		animation.play("arrow")

	move_and_slide()

func die():
	get_tree().reload_current_scene()
