extends Camera3D

const sensitivity := 0.002

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		rotation.y = clamp(rotation.y, deg_to_rad(-80), deg_to_rad(80))
		rotate_x(-event.relative.y * sensitivity)
		rotation.x = clamp(rotation.x, deg_to_rad(-50), deg_to_rad(50))
		#rotation.z = 0.0
