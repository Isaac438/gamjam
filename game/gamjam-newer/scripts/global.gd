extends Node

var debug_message := "welcome to your driver's test"
var player_position := Vector3(0.0, 5.0, 0.0)
var time_played := 0.0
var going := true

func _process(delta: float) -> void:
	prints(going,time_played)
	if going:
		time_played += delta
