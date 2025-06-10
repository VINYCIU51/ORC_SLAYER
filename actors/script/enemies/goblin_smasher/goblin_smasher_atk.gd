extends Area2D

var mob = Goblin_smasher

func _on_body_entered(body: Node2D) -> void:
	# se o player tiver entrado em contato com a area, ele toma o dano referente á força do mob
	if body.name == "player":
		body.take_damage(mob.DAMAGE)
		

func _on_area_entered(area: Area2D) -> void:
	# se  player estiver com o parry ativo no momento do impacto, o mob recebe um parry
	if area.name == "parry":
		mob.has_parried = true
