extends VehicleBody3D

const steer_speed: float = 1.0
const steer_diminish: float = 1.0
const speed_modifier := 0.5

const max_engine_force := 50.0
const reverse_max_force := 40.0
const brake_max := 5.0

const accel := 100.0
const decel := 75.0
const brake_accel := 30.0

func _process(delta: float) -> void:
	var target_force := 0.0
	var target_brake := 0.0
	var forward_speed := linear_velocity.dot(-global_transform.basis.z)

	if Input.is_action_pressed("gas"):
		if forward_speed < -1.0:
			target_brake = brake_max
		else:
			target_force = max_engine_force
			target_brake = 0.0

	elif Input.is_action_pressed("brake"):
		if forward_speed > 1.0:
			target_brake = brake_max
		else:
			target_force = -reverse_max_force
			target_brake = 0.0

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
		var steer_max := speed_modifier / linear_velocity.length()
		if steer_max > 0.4:
			steer_max = 0.4
		
		steering = move_toward(
			steering,
			steer_max,
			steer_speed*delta
		)
		
	elif Input.is_action_pressed("turn_right"):
		var steer_max := -speed_modifier / linear_velocity.length()
		if steer_max < -0.4:
			steer_max = -0.4
		steering = move_toward(
			steering,
			steer_max,
			steer_speed*delta
		)
		
	else:
		if steering > 0.02:
			steering = move_toward(
				steering,
				0.0,
				steer_diminish*delta
			)
		elif steering < 0.02:
			steering = move_toward(
				steering,
				0.0,
				steer_diminish*delta
			)
		else:
			steering = 0.0
