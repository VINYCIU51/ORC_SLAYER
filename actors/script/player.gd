extends CharacterBody2D

const ARROW := preload("res://actors/scenes/projectiles/arrow.tscn")
const SPEED = 400.0
const JUMP_VELOCITY = -400.0
const DEATH_HEIGHT = 1000.0

var direction = Vector2.ZERO
var is_attacking = false

func _physics_process(delta):
	
# MORRE CASO CAIA NESTA AREA
	if global_position.y > DEATH_HEIGHT:
		die()
	
	if is_attacking:
		# IMPEDE QUE OUTRAS ANIMAÇÕES ATRAPALHEM AS DE ATAQUE
		if not $animation.is_playing():
			is_attacking = false
		move_and_slide()
		return
	
	# APLICA A GRAVIDADE
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	else:
		if velocity.x == 0: 
			$animation.play("idle")
	
# EFETUA O SALTO
	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$animation.play("jump")    

# EFETUA O MOVIMENTO DO PERSONAGEM
	if Input.is_key_pressed(KEY_D):
		direction.x = 1 
		$sprite.flip_h = false
		
		if sign($arrow_point.position.x) == -1:
			$arrow_point.position.x *= -1
		
	elif Input.is_key_pressed(KEY_A): 
		direction.x = -1
		$sprite.flip_h = true
		
		if sign($arrow_point.position.x) == 1:
			$arrow_point.position.x *= -1
		
	else:
		direction.x = 0

# MOVIMENTO
	velocity.x = direction.x * SPEED

# APLICA A ANIMAÇÃO DE CAMINHAR
	if is_on_floor() and direction.x != 0:
		$animation.play("walk")

# EFETUA OS ATAQUES DE ESPADA
	if is_on_floor() and Input.is_action_just_pressed("left_click"):
		velocity.x = 0
		is_attacking = true
		$animation.play("atack")

# EFETUA OS ATAQUES DE FLECHA
	if is_on_floor() and Input.is_action_just_pressed("right_click"):
		
#		ATIRA AS FLECHAS INFORMANDO A DIREÇAO CORRETA
		if sign($arrow_point.position.x) == 1:
			shoot_arrow(1)
		else:
			shoot_arrow(-1)
		
		velocity.x = 0 # PARA O PLAYER
		is_attacking = true # IMPEDE INTERRUPÇOES
		$animation.play("arrow") # CHAMA A ANIMAÇAO

	move_and_slide()

# FUNÇAO DE MORTE
func die():
	get_tree().reload_current_scene() # RECARREGA O JOGO DO INICIO

# FUNÇAO PARA ATIRAR FLECHAS
func shoot_arrow(direct):
	await get_tree().create_timer(0.5).timeout # ESPERA UM TEMPO PARA SINCRONIZAR COM A ANIMACAO
	
	var arrow_instance = ARROW.instantiate() # CRIA A INSTANCIA DA FLECHA
	get_parent().add_child(arrow_instance) # FAZ ELA APARECER NA TELA DO MUNDO
	arrow_instance.set_direction(direct) # DEFINE PARA QUE LADO A FLECHA VAI
	arrow_instance.position = $arrow_point.global_position # FAZ ELA SAIR DA MAO DO PLAYER
