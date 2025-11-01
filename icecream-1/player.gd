extends CharacterBody2D


const SPEED = 200


func _physics_process(_delta):
	var acc = Input.get_accelerometer()

	velocity.x = acc.x * SPEED
	velocity.y = -acc.y * SPEED * 2

	move_and_slide()
