class_name Skeleton_axe
extends Enemy

func _ready() -> void:
	super._ready()
	
	speed = 80
	life = 6
	damage = 2
	parry_resistance = 2
	dist_mellee = 25
	should_jump = true
	flip_compensation = -3
