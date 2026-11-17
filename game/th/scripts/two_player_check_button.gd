extends CheckButton

func _toggled(toggled_on: bool) -> void:
	global.two_player = toggled_on
