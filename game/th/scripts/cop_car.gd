extends VehicleBody3D

@export var nav_agent: NavigationAgent3D

const steer_speed: float = 1.0
const steer_diminish: float = 1.0
const speed_modifier := 1.5

const max_engine_force := 100.0
const reverse_max_force := 80.0
const brake_max := 2.0

const accel := 100.0
const decel := 50.0
const brake_accel := 30.0

var time_since_movement := 0.0
var position_last_frame : Vector3

func _ready() -> void:
	position_last_frame = global_position

var t := randf_range(0.0, 0.5)
func _process(delta: float) -> void:
	t += delta
	if t > 0.5:
		t = 0.0
		nav_agent.target_position = global.player_position

var time := randf_range(0.0, 0.1)
func _physics_process(delta: float) -> void:
	time += delta
	if time >= 0.1:
		recalculate_physics(time)
		time = 0.0
	
func recalculate_physics(delta: float) -> void:
	var target_force := 0.0
	var target_brake := 0.0
	var forward_speed := linear_velocity.dot(-global_transform.basis.z)
	var next_point := nav_agent.get_next_path_position()
	var next_point_is_forwards := (next_point - global_position).normalized().dot(-self.global_transform.basis.z.normalized()) > 0 #some random trig stuff i have no idea how work
	var next_point_is_right := (next_point - global_position).normalized().dot(self.global_transform.basis.x.normalized()) > 0
	
	if global_position.distance_squared_to(position_last_frame) > 0.0001:
		time_since_movement = 0.0
	else:
		time_since_movement += delta
		
	if time_since_movement > 5.0 or global_position.y < -5.0:
		get_parent().spawn_car()
		queue_free()
		return
	position_last_frame = global_position

	if next_point_is_forwards and forward_speed < 15.0:
		if forward_speed < -1.0:
			target_brake = brake_max
		else:
			target_force = max_engine_force
			target_brake = 0.0

	elif !next_point_is_forwards:
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
	
	if !next_point_is_right:
		var steer_max := speed_modifier / linear_velocity.length()
		if steer_max > 0.6:
			steer_max = 0.6
		
		steering = move_toward(
			steering,
			steer_max,
			steer_speed*delta
		)
		
	elif next_point_is_right:
		var steer_max := -speed_modifier / linear_velocity.length()
		if steer_max < -0.5:
			steer_max = -0.5
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
