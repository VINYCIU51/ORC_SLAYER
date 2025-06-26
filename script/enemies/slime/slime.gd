class_name Slime
extends Enemy

func _ready() -> void:
	super._ready()
	
	life = 3
	speed = 50
	should_jump = false
