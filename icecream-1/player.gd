#extends CharacterBody2D
#
#
#const SPEED = 200
#var hp = 10  # 初始生命值
#
#func _ready():
	#print("Player准备好了，HP:", hp)
	## 检查Area2D是否存在
	#if has_node("Area2D"):
		#print("找到Area2D")
	#else:
		#print("警告：找不到Area2D！")
#
#
#func _physics_process(_delta):
	#var acc = Input.get_accelerometer()
#
	#velocity.x = acc.x * SPEED
	#velocity.y = -acc.y * SPEED * 2
#
	#move_and_slide()
#
#
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("检测到碰撞！碰到的物体名字:", body.name)
	## 检查碰到的是否是flower
	#if body.name.begins_with("flower"):
		#hp += 1
		#print("HP增加: ", hp)
		#body.queue_free()  # 移除花朵


extends CharacterBody2D
const SPEED = 200
var hp = 10  # 初始生命值
var hp_label  # 引用UI上的Label

func _ready():
	print("Player准备好了，HP:", hp)
	# 获取Label节点（根据你的节点路径调整）
	hp_label = get_node("/root/base/ui/Label")
	update_hp_display()

func _physics_process(_delta):
	var acc = Input.get_accelerometer()
	velocity.x = acc.x * SPEED
	velocity.y = -acc.y * SPEED * 2
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		return
	
	if body.name.to_lower().begins_with("flower"):
		hp += 1
		print("HP增加: ", hp)
		update_hp_display()  # 更新UI显示
		body.queue_free()

func update_hp_display():
	if hp_label:
		hp_label.text = "HP: " + str(hp)
