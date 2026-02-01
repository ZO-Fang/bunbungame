extends Node

var elapsed_seconds: int = 0
var running: bool = false
var final_seconds: int = 0


func start():
	elapsed_seconds = 0
	running = true

func stop():
	running = false
	final_seconds = elapsed_seconds

func _process(delta):
	if running:
		elapsed_seconds += delta
