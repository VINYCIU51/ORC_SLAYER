extends CharacterBody2D

var damage := 1

func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		queue_free()
