	
extends TextureButton

func _on_pressed() -> void:
	GameConfig.mode = GameConfig.GameMode.EASY
	GameConfig.time_limit = 0
	get_tree().change_scene_to_file("res://base.tscn")
