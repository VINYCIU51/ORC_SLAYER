class_name Skeleton_seeker
extends Enemy

func _ready() -> void:
	super._ready()
	
	life = 8
	damage = 2
	speed = 70
	should_jump = false
	has_spawned = false
