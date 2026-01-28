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

#-----------------------------------------------------------------

#extends CharacterBody2D
#const SPEED = 200
#var hp = 10  # 初始生命值
#var hp_label  # 引用UI上的Label
#
#func _ready():
	#print("Player准备好了，HP:", hp)
	## 获取Label节点（根据你的节点路径调整）
	#hp_label = get_node("/root/base/ui/Label")
	#update_hp_display()
#
#func _physics_process(_delta):
	#var acc = Input.get_accelerometer()
	#velocity.x = acc.x * SPEED
	#velocity.y = -acc.y * SPEED * 2
	#move_and_slide()
#
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#if body == self:
		#return
	#
	#if body.name.to_lower().begins_with("flower"):
		#hp += 1
		#print("HP增加: ", hp)
		#update_hp_display()  # 更新UI显示
		#body.queue_free()
#
#func update_hp_display():
	#if hp_label:
		#hp_label.text = "HP: " + str(hp)
		
		

#---------------------------------------------------------------------


extends CharacterBody2D
var SPEED := 150
var hp = 10  # 初始生命值
var hp_label  # 引用UI上的Label

var smash_power := 0.0        # 本帧的摆动力度
var prev_acc := Vector3.ZERO  # 上一帧的加速度
var SMASH_THRESHOLD := 7.0   # 阈值，数值可调（10~15 比较合理）

var is_in_mud := false
var normal_speed := SPEED
var mud_speed := SPEED * 0.2     # 降到20%
var mud_duration := 10.0         # 持续10秒

var is_frozen := false
var freeze_damage_interval := 2.0   # 每2秒掉一次血
var freeze_break_threshold := 300.0   # 逃脱所需的摆动力量
var freeze_timer_running := false   # 防止重复开计时器



func _ready():
	print("Player准备好了，HP:", hp)
	# 获取Label节点（根据你的节点路径调整）
	call_deferred("_init_hp_label")
	#hp_label = get_node("/root/base/ui/Label")
	update_hp_display()

func _init_hp_label():
	hp_label = get_node("/root/base/ui/Label")
	update_hp_display()  # 初始化显示


func _physics_process(delta):
	var acc = Input.get_accelerometer()

	# 计算摆动强度 = 当前加速度变化量
	smash_power = (acc - prev_acc).length() * 10

	# 保存给下一帧用
	prev_acc = acc

	# 正常移动
	velocity.x = acc.x * SPEED
	velocity.y = -acc.y * SPEED * 2
	move_and_slide()
	#print(smash_power)
	
	# 如果冻结期间，检测摆动
	if is_frozen:
		if smash_power > freeze_break_threshold:
			print("摆动力量达到", smash_power, "成功挣脱冰块！")
			remove_freeze()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		return

	# 花朵逻辑
	if body.name.to_lower().begins_with("flower"):
		print("检测到花朵!") 
		hp += 1
		update_hp_display()
		body.queue_free()
		return

	# 木板逻辑
	if body.name.to_lower().begins_with("woodboard"):  
		print("木板检测到!") 
		if smash_power > SMASH_THRESHOLD:
			print("此刻撞破了！ smash=", smash_power) 
			body.break_wood()      # 调用木板脚本的破碎函数
		return	
			
			
	if body.name.to_lower().begins_with("ice"):
		print("检测到冰块！")
		apply_freeze()
		return
				
	#if body.name.to_lower().begins_with("mud"):
		#print("检测到泥地！")
		#apply_mud_effect()
		#return



func update_hp_display():
	if hp_label:
		hp_label.text = "HP: " + str(hp)
		

func apply_mud_effect():
	if is_in_mud:
		return  # 已经有泥巴效果，避免重复触发

	is_in_mud = true

	# 换成黑色动画
	$AnimatedSprite2D.play("dark-walk")

	# 降速
	SPEED = mud_speed

	# 开始一个异步 10 秒计时器（不会卡住游戏）
	mud_timer()


func mud_timer() -> void:
	await get_tree().create_timer(mud_duration).timeout
	remove_mud_effect()

	
func remove_mud_effect():
	if not is_in_mud:
		return

	is_in_mud = false

	# 恢复颜色动画
	$AnimatedSprite2D.play("walk")   # 或你白色的那个动画名

	# 恢复速度
	SPEED = normal_speed
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	var name := area.name.to_lower()

	if name.begins_with("mud"):
		print("检测到泥地！（Area2D）")
		hp -=1
		update_hp_display()
		apply_mud_effect()
		check_player_dead()
		return
# Replace with function body.

func apply_freeze():
	if is_frozen:
		return

	is_frozen = true
	SPEED = 0  # 玩家无法移动
	$AnimatedSprite2D.play("frozen")
	print("玩家被冻结。速度=0")

	# 启动持续掉血计时器
	start_freeze_damage_loop()


func start_freeze_damage_loop() -> void:
	if freeze_timer_running:
		return
	freeze_timer_running = true

	while is_frozen:
		await get_tree().create_timer(freeze_damage_interval).timeout
		if not is_frozen:
			break  # 死亡或解冻立即停止

		hp -= 1
		update_hp_display()
		print("冻结伤害！hp -1 =", hp)
		check_player_dead()   # 如果死亡，会把 is_frozen 设为 false
	

	freeze_timer_running = false



func remove_freeze():
	if not is_frozen:
		return

	is_frozen = false
	freeze_timer_running = false   # ← 很重要，协程要停止
	SPEED = normal_speed  # 恢复正常速度
	$AnimatedSprite2D.play("walk")
	print("冻结解除！速度恢复")
		
		
func check_player_dead():
	if hp <= 0:
		print("玩家死亡！切换到死亡场景。")
		is_frozen = false
		freeze_timer_running = false
		call_deferred("_go_to_lose_scene")

func _go_to_lose_scene():
	get_tree().change_scene_to_file("res://youlose.tscn")


func _exit_tree():
	# 玩家即将被删除时，强制停止冻结循环
	is_frozen = false
	freeze_timer_running = false
