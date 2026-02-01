extends TextureButton


func _on_pressed() -> void:
	GameConfig.mode = GameConfig.GameMode.NORMAL
	GameConfig.time_limit = 180
	get_tree().change_scene_to_file("res://base.tscn")
