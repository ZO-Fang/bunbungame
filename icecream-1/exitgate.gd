extends Area2D

@export var next_scene_path: String = "res://bg2.tscn"
@export var player_new_position: Vector2

func _on_body_entered(body):
	if body.name == "player":
		call_deferred("deferred_switch_map")

func deferred_switch_map():
	var map_container = get_node("/root/base/Node2D")
	
	# empty all the maps
	for child in map_container.get_children():
		child.queue_free()
	
	# load and add new map
	var new_map = load(next_scene_path).instantiate()
	map_container.add_child(new_map)
	
	# give player a new position at next map
	if player_new_position != Vector2.ZERO:
		var player = get_node("/root/base/player")
		player.global_position = player_new_position
	
	print("changed to: ", next_scene_path)	
