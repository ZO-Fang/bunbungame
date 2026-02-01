extends Node2D

var time_left := 0.0

func _ready():
    if GameConfig.time_limit > 0:
        time_left = GameConfig.time_limit
        $ui/HBoxContainer/TimerLabel.visible = true
    else:
        $ui/HBoxContainer/TimerLabel.visible = false
        $ui/HBoxContainer/TextureRect.visible = false

func _process(delta):
    if GameConfig.time_limit <= 0:
        return

    time_left -= delta
    var seconds := int(ceil(time_left))
    $ui/HBoxContainer/TimerLabel.text = "%d" % seconds

    if time_left <= 0:
        get_tree().change_scene_to_file("res://youlose.tscn")
