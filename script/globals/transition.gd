extends Node

# Dicionario para guardar os caminhos das transicoes
var scenes : Dictionary = {"menu":"res://scenes/interface/main_menu.tscn",
						  "tutorial":"res://scenes/worlds/tutorial.tscn",
						  "forest":"res://scenes/worlds/forest.tscn",
						  "cave":"res://scenes/worlds/cave.tscn"
}

func to(level : String):
	var scene_path :String = scenes.get(level)
	
	if scene_path != null:
		PauseMenu.pause_enabled = false # desativa o pause durante a transicao
		await LoadingScreen.start()
		
		PlayerInterface.show() # exibe a vida do player
		get_tree().change_scene_to_file(scene_path) # faz a transicao no momento em que a tela esta escura

		await get_tree().process_frame
		
		await LoadingScreen.end()
		PauseMenu.pause_enabled = true # reativa o pause
