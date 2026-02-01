
#---------------------------------------------------------------------


extends CharacterBody2D
var SPEED := 150
var hp = 10  
var hp_label  

var smash_power := 0.0        
var prev_acc := Vector3.ZERO  
var SMASH_THRESHOLD := 7.0   

var is_in_mud := false
var normal_speed := SPEED
var mud_speed := SPEED * 0.2     
var mud_duration := 10.0         

var is_frozen := false
var freeze_damage_interval := 2.0   
var freeze_break_threshold := 300.0   
var freeze_timer_running := false   



func _ready():
	print("Player is ready, HP:", hp)
	call_deferred("_init_hp_label")
	update_hp_display()

func _init_hp_label():
	hp_label = get_node("/root/base/ui/HBoxContainer2/Label")
	update_hp_display()  


func _physics_process(delta):
	var acc = Input.get_accelerometer()

	smash_power = (acc - prev_acc).length() * 10

	prev_acc = acc

	velocity.x = acc.x * SPEED
	velocity.y = -acc.y * SPEED * 2
	move_and_slide()
	
	if is_frozen:
		if smash_power > freeze_break_threshold:
			print("the smashing power is", smash_power, "escape from ice！")
			remove_freeze()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		return

	if body.name.to_lower().begins_with("flower"):
		print("detect flower!") 
		hp += 1
		update_hp_display()
		body.queue_free()
		return

	if body.name.to_lower().begins_with("woodboard"):  
		print("detect a woodboard!") 
		if smash_power > SMASH_THRESHOLD:
			print("Woodboard is broken！ smash=", smash_power) 
			body.break_wood()      
		return	
			
			
	if body.name.to_lower().begins_with("ice"):
		print("detect ice!")
		apply_freeze()
		return
			



func update_hp_display():
	if hp_label:
		hp_label.text = str(hp)
		

func apply_mud_effect():
	if is_in_mud:
		return  

	is_in_mud = true

	$AnimatedSprite2D.play("dark-walk")

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

	#改到普通动画
	$AnimatedSprite2D.play("walk")   

	# 恢复速度
	SPEED = normal_speed
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	var name := area.name.to_lower()

	if name.begins_with("mud"):
		print("Detect mud!（Area2D）")
		hp -=1
		update_hp_display()
		apply_mud_effect()
		check_player_dead()
		return


func apply_freeze():
	if is_frozen:
		return

	is_frozen = true
	SPEED = 0  
	$AnimatedSprite2D.play("frozen")
	print("player is frozen. Speed=0")

	# start the losing HP timer
	start_freeze_damage_loop()


func start_freeze_damage_loop() -> void:
	if freeze_timer_running:
		return
	freeze_timer_running = true

	while is_frozen:
		await get_tree().create_timer(freeze_damage_interval).timeout
		if not is_frozen:
			break  # if player is dead, or escaped from ice, stop this

		hp -= 1
		update_hp_display()
		print("ice damage. hp -1 =", hp)
		check_player_dead()  
	

	freeze_timer_running = false



func remove_freeze():
	if not is_frozen:
		return

	is_frozen = false
	freeze_timer_running = false   # ← 很重要，协程要停止
	SPEED = normal_speed  # 恢复正常速度
	$AnimatedSprite2D.play("walk")
	print("escaped from frozen, back to normal speed")
		
		
func check_player_dead():
	if hp <= 0:
		print("player is dead. switch to dead scene")
		is_frozen = false
		freeze_timer_running = false
		call_deferred("_go_to_lose_scene")

func _go_to_lose_scene():
	get_tree().change_scene_to_file("res://youlose.tscn")


func _exit_tree():
	# 玩家即将被删除时，强制停止冻结循环
	is_frozen = false
	freeze_timer_running = false
