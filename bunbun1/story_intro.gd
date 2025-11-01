# story_intro.gd
extends Control

var current_image = 0
var images = [
	preload("res://drawings/download.jpg"),
	preload("res://drawings/intropic2.jpg")
]
@onready var texture_rect = $TextureRect

func _ready():
	show_image(0)

func _input(event):
	# 只响应鼠标按下（不响应释放）
	if event is InputEventMouseButton and event.pressed:
		next_image()
		get_viewport().set_input_as_handled()  # 防止事件继续传播

func show_image(index):
	texture_rect.texture = images[index]

func next_image():
	current_image += 1
	if current_image < images.size():
		show_image(current_image)
	else:
		get_tree().change_scene_to_file("res://map1.tscn")
