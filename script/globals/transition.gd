extends Node

var scenes : Dictionary = {"Menu_principal":"res://UI/menu_principal/scenes/menuprincipal.tscn",
						  "tutorial":"res://scenes/worlds/tutorial.tscn",
						  "forest":"res://scenes/worlds/forest.tscn",
						  "cave":"res://scenes/worlds/cave.tscn"
}

func to(level : String):
	var scene_path :String = scenes.get(level)
	
	if scene_path != null:
		await LoadingScreen.start()
		
		get_tree().change_scene_to_file(scene_path)

		await get_tree().process_frame
		
		await LoadingScreen.end()
