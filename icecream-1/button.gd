# 在 youwin.tscn 中给 Button 添加的脚本
extends Button

func _ready():
	# 连接按下信号
	pressed.connect(_on_pressed)

func _on_pressed():
	# 重新开始游戏
	get_tree().change_scene_to_file("res://base.tscn")  # 替换为你的主场景文件
