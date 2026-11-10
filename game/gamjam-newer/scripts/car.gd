extends VehicleBody3D

@onready var head: Node3D = $Head
@onready var cab_camera: Camera3D = $Head/CabCamera
@onready var camera_arm: SpringArm3D = $Head/CameraArm
@onready var third_person_camera: Camera3D = $Head/CameraArm/ThirdPersonCamera

const steer_speed: float = 1.0
const steer_diminish: float = 1.0
const speed_modifier := 1.5

const max_engine_force := 50.0
const reverse_max_force := 40.0
const brake_max := 2.0

const accel := 100.0
const decel := 50.0
const brake_accel := 30.0

const SENS: float = 0.003

var third_person_camera_mode: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	third_person_camera.current = false
	cab_camera.current = true
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if !third_person_camera_mode:
			head.rotate_y(-event.relative.x * SENS)
			cab_camera.rotate_x(-event.relative.y * SENS)
			rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))
		else:
			head.rotate_y(-event.relative.x * SENS)
			camera_arm.rotate_x(-event.relative.y * SENS)
			rotation.x = clamp(rotation.x, deg_to_rad(-45), deg_to_rad(90))
			
	if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif Input.is_action_just_pressed("escape_key") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		#print("escape detected")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	var target_force := 0.0
	var target_brake := 0.0
	var forward_speed := linear_velocity.dot(-global_transform.basis.z)
	
	if forward_speed > 7.0:
		global.debug_message = "Slow it dow therre boy"
	else:
		global.debug_message = ""
	
	if Input.is_action_just_pressed("camera_toggle"):
		third_person_camera_mode = !third_person_camera_mode
		cab_camera.current = !third_person_camera_mode
		third_person_camera.current = third_person_camera_mode

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
		if steer_max > 0.6:
			steer_max = 0.6
		
		steering = move_toward(
			steering,
			steer_max,
			steer_speed*delta
		)
		
	elif Input.is_action_pressed("turn_right"):
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
