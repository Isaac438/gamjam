extends Button

func _pressed() -> void:
	global.gear = clamp(global.gear - 1, 0, 3)
