extends Button

func _pressed() -> void:
	global.gear2p = clamp(global.gear2p + 1, 0, 3)
