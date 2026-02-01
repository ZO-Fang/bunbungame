extends StaticBody2D

func break_wood():
	# change broken wood image
	$Sprite2D.texture = preload("res://images/tools/woodboard-broken.png")
	
		# make this wood disappear from the game physical world
	$CollisionShape2D.set_deferred("disabled", true)
	
	
