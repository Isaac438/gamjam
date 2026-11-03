extends VehicleBody3D

const steer_speed : float = 4.0
const brake_power : float = 5.0
const steer_diminish : float = 1.5

func _process(delta: float) -> void:
	if Input.is_action_pressed("gas"):
		if engine_force < 25.0:
			engine_force += 25.0*delta
		else:
			engine_force = 25.0
	else:
		if engine_force > 0:
			engine_force -= 25.0*delta
		else:
			brake = 0
	if Input.is_action_pressed("brake"):
		brake += brake_power*delta
	else:
		if brake > 0:
			brake -= 10*delta
		else:
			brake = 0
	if Input.is_action_pressed("turn_left"):
		if steering < 0.4:
			steering += delta * steer_speed
	else:
		if steering > 0.02:
			steering -= steer_diminish*delta
		elif steering < 0.02:
			steering += steer_diminish*delta
		else:
			steering = 0.0
	if Input.is_action_pressed("turn_right"):
		if steering > -0.4:
			steering -= delta * steer_speed

	print(engine_force)
