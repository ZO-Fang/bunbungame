#extends Area2D
#
#func _on_body_entered(body):
	#if body.name == "player":
		#reveal_next_map()
#
#func reveal_next_map():
	#var bg1 = get_node("/root/base/Node2D/bg1")
	#if bg1:
		#bg1.queue_free()
		#print("切换到 bg2")
	## 如果想要更多层，可以继续处理 bg2 显示 bg3 等

#extends Area2D
#
#@export var next_scene_path: String = "res://bg2.tscn"
#@export var player_new_position: Vector2
#
#func _on_body_entered(body):
	#if body.name == "player":
		#switch_map()
#
#func switch_map():
	#var map_container = get_node("/root/base/Node2D")
	#
	## 清空容器内的所有地图
	#for child in map_container.get_children():
		#child.queue_free()
	#
	## 加载并添加新地图
	#var new_map = load(next_scene_path).instantiate()
	#map_container.add_child(new_map)
	#
	## 重置玩家位置
	#if player_new_position != Vector2.ZERO:
		#var player = get_node("/root/base/player")
		#player.global_position = player_new_position
	#
	#print("切换到: ", next_scene_path)
	
extends Area2D

@export var next_scene_path: String = "res://bg2.tscn"
@export var player_new_position: Vector2

func _on_body_entered(body):
	if body.name == "player":
		# 使用 call_deferred 来安全地切换场景
		call_deferred("deferred_switch_map")

func deferred_switch_map():
	var map_container = get_node("/root/base/Node2D")
	
	# 清空容器内的所有地图
	for child in map_container.get_children():
		child.queue_free()
	
	# 加载并添加新地图
	var new_map = load(next_scene_path).instantiate()
	map_container.add_child(new_map)
	
	# 重置玩家位置
	if player_new_position != Vector2.ZERO:
		var player = get_node("/root/base/player")
		player.global_position = player_new_position
	
	print("切换到: ", next_scene_path)	
