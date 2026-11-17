extends Node

var debug_message := "run fast!"
var player_position := Vector3(0.0, 5.0, 0.0)
var time_played := 0.0
var going := true
var gear := 1
var gear2p := 1
var touch_screen := false
var two_player := false

func _process(delta: float) -> void:
	if going:
		time_played += delta
