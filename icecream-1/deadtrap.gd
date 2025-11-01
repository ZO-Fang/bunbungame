extends Area2D

# 预加载游戏结束场景（方案2需要）
# const GAME_OVER_SCENE = preload("res://game_over.tscn")

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# 检查是否是玩家（确保节点名称匹配）
	if body.name == "player": 
		game_over()

func game_over():
	print("Game Over!")
	
	# 方案1：使用 CanvasLayer 显示 Game Over（推荐）
	var ui = show_game_over_ui()
	
	# 等待2秒后重新开始
	await get_tree().create_timer(2.0).timeout
	
	# 删除 Game Over UI
	ui.queue_free()
	
	# 重新加载场景
	get_tree().reload_current_scene()

func show_game_over_ui():
	# 创建一个 CanvasLayer（确保UI显示在最上层）
	var canvas_layer = CanvasLayer.new()
	canvas_layer.name = "GameOverUI"  # 给它一个名字，方便后续删除
	get_tree().root.add_child(canvas_layer)
	
	# 创建半透明黑色背景
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.7)  # 黑色，70%透明度
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)  # 填满整个屏幕
	canvas_layer.add_child(overlay)
	
	# 创建 Game Over 文字
	var label = Label.new()
	label.text = "GAME OVER"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# 设置文字样式
	label.add_theme_font_size_override("font_size", 64)
	label.add_theme_color_override("font_color", Color.RED)
	
	# 让文字居中显示
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas_layer.add_child(label)
	
	# 返回 canvas_layer，方便后续删除
	return canvas_layer
