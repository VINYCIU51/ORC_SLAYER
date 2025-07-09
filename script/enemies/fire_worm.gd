class_name Fire_worm
extends Enemy 

func _ready() -> void:
	super._ready()
	
	life = 6
	speed = 60
	dist_mellee = 0
	should_jump = false
