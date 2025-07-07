extends Enemy
class_name Boss_forest

func _ready() -> void:
	super._ready()
	
	life = 30
	speed = 60
	damage = 1
	num_range_attacks = 2
	max_parry_resistance = 15
	dist_follow = 350
	dist_mellee = 55
	should_jump = true
	flip_compensation = -36
	position_compensation = 36

#func _physics_process(delta: float) -> void:
	#super._physics_process(delta)
	#
	#var distance = Mobs.distance_to(self, player)
	#
	#if distance > dist_follow:
		#var attack_range = randi_range(1, 2)
		#
		#if attack_range == 1:
			#animation.play("attack_2")
		#else:
			#animation.play("teleport")
