extends Enemy
class_name Boss_forest

func _ready() -> void:
	super._ready()
	
	life = 3
	speed = 80
	damage = 1
	num_attacks = 2
	max_parry_resistance = 1
	dist_mellee = 25
	should_jump = true
	flip_compensation = -36
