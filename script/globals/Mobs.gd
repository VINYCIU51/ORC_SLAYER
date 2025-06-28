extends Node

func shoot(projectile : PackedScene, parent : Node, position : Vector2, direction : int):
	var projectile_instance = projectile.instantiate()
	parent.add_sibling(projectile_instance, true)
	
	projectile_instance.set_direction(sign(direction))
	projectile_instance.position = position

#func get_player(node : Node):
	#var current_node = node
	#while current_node:
		#if current_node.get_node("player"):
			#var player = current_node.get_node("player")
			#return player
		#current_node = current_node.get_parent()
	#return null
	
#func get_player():
	#var root = get_tree().get_current_scene()
	#if root:
		#var player = root.get_node("player")
		#if player:
			#return player

#func get_player(start_node: Node) -> Node:
	#var current = start_node
	#while current:
		#var player = current.get_node_or_null("player")
		#if player:
			#return player
		#current = current.get_parent()
	#return null

func get_player(node: Node) -> Node:
	var current = node
	while current:
		var player = current.get_parent().get_node_or_null("player")
		if player:
			return player
		current = current.get_parent()
	return null
		

func hit_blink(sprite : Node):
	sprite.self_modulate = Color(50,50,50,1)
	await get_tree().create_timer(0.1).timeout
	sprite.self_modulate = Color(1,1,1,1)

func distance_to(parent : Node, target : Node):
	var distance = parent.global_position.distance_to(target.global_position)
	return distance
	
func is_below(parent : Node, target : Node):
	var horizontal_difference = abs(parent.global_position.x - target.global_position.x)
	var is_below_target = parent.global_position.y > target.global_position.y or parent.global_position.y < target.global_position.y
	var is_exactly_below = horizontal_difference < 2 and is_below_target
	
	return is_exactly_below
	
func take_stun(target: Node, duration := 2.0):
	target.is_stuned = true
	await get_tree().create_timer(duration).timeout

	if is_instance_valid(target):
		target.is_stuned = false
	
func apply_damage(target: Node, damage: int):
	if target.is_dead or damage == 0:
		return false
	
	target.is_damaged = true
	target.life -= damage *2 if target.is_stuned else damage
	
	if target.life <= 0:
		target.is_dead = true
	return true
