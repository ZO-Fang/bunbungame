extends Area2D

@export var target_black_hole: Node2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "player":
		body.global_position = target_black_hole.global_position
