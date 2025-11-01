# exitgate.gd
extends Area2D

@export_file("*.tscn") var next_map_path: String

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "bunbun" and next_map_path != "":
		get_tree().change_scene_to_file(next_map_path)
		
		
