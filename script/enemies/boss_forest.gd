extends Enemy
class_name Boss_forest

func _ready() -> void:
	super._ready()
	
	life = 30
	speed = 60
	damage = 1
	num_range_attacks = 2
	max_parry_resistance = 15
	dist_follow = 420
	dist_mellee = 55
	flip_compensation = -36
	position_compensation = 36
