extends CheckButton

func _toggled(toggled_on: bool) -> void:
	global.touch_screen = toggled_on
