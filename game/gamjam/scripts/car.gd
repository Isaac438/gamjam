extends VehicleBody3D

const steer_speed: float = 4.0
const steer_diminish: float = 1.5

const max_engine_force := 50.0
const reverse_max_force := 40.0
const brake_max := 5.0

const accel := 100.0
const decel := 75.0
const brake_accel := 30.0

func _process(delta: float) -> void:
	var target_force := 0.0
	var target_brake := 0.0

	if Input.is_action_pressed("gas"):
		target_force = max_engine_force

	elif Input.is_action_pressed("brake"):
		if linear_velocity.length() > 1.0:
			target_brake = brake_max
		else:
			target_force = -reverse_max_force

	var force_rate := accel

	if target_force == 0.0:
		force_rate = decel

	engine_force = move_toward(
		engine_force,
		target_force,
		force_rate * delta
	)

	brake = move_toward(
		brake,
		target_brake,
		brake_accel * delta
	)
	
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
