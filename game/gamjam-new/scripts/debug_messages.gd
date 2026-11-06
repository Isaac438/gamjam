extends Label

var t := 0.0

func _process(delta: float) -> void:
	t += delta
	
	if t >= 1.0:
		t = 0.0
		if global.debug_message != text:
			text = global.debug_message
