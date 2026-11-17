extends Label

func _ready() -> void:
	global.going = false
	text = text + "\nTime Played: " + str(int(round(global.time_played))) + " Seconds"
