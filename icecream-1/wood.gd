extends Node2D

@onready var sprite := $Sprite2D
@onready var static_col := $StaticBody2D/CollisionShape2D
@onready var detector := $Area2D
@onready var detector_col := $Area2D/CollisionShape2D

var is_broken := false
var broken_texture := preload("res://images/tools/wood2.png")

func break_wood():
	if is_broken:
		return

	is_broken = true

	# 更换贴图
	sprite.texture = broken_texture

	# 禁用阻挡碰撞
	static_col.disabled = true

	# 也关掉检测器，避免重复触发
	detector_col.disabled = true


func _on_area_2d_body_entered(body):
	# 玩家本体进入检测区
	if body.name == "player":
		if body.smash_power > body.SMASH_THRESHOLD:
			break_wood()
