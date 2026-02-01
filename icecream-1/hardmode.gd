extends TextureButton



func _on_pressed() -> void:
	GameConfig.mode = GameConfig.GameMode.HARD
	GameConfig.time_limit = 120.0   
	get_tree().change_scene_to_file("res://base.tscn")
