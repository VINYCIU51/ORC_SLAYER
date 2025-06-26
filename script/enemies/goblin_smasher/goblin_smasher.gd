class_name Goblin_smasher
extends Enemy

func _ready() -> void:
	super._ready()
	life = 3
	speed = 110
	damage = 1
	dist_mellee = 25
	parry_resistance = 1
	should_jump = true
