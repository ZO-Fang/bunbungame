extends StaticBody2D

func break_wood():
	# 换碎木贴图
	$Sprite2D.texture = preload("res://images/tools/woodboard-broken.png")
	
		# 禁用碰撞（必须用 set_deferred）
	$CollisionShape2D.set_deferred("disabled", true)
	
	
