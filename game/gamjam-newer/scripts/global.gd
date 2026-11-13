extends Node

var debug_message := "run fast!"
var player_position := Vector3(0.0, 5.0, 0.0)
var time_played := 0.0
var going := true
var gear := 1

func _process(delta: float) -> void:
	if going:
		time_played += delta
