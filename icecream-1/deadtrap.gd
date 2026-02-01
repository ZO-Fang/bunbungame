extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "player":
		die()

func die():
	print("this is a dead zone，player is dead")
	call_deferred("_change_scene")
	

func _change_scene():
	get_tree().change_scene_to_file("res://youlose.tscn")
