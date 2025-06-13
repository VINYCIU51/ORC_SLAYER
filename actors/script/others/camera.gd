extends Camera2D

@export var target_path: NodePath

var target: Node2D = null

func _ready():
	if target_path:
		target = get_node(target_path)
	self.enabled = true  # Ativa a câmera

func _process(delta):
	if target and is_instance_valid(target):
		global_position = target.global_position
