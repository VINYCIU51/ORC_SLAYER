extends Camera2D

@export var target_path: NodePath

var target: Node2D = null

func _ready():
	# conecta com o objeto de foco, no caso o player
	if target_path:
		target = get_node(target_path)
	self.enabled = true

func _process(_delta):
	# faz a camera seguir o player 
	if target and is_instance_valid(target):
		global_position = target.global_position
