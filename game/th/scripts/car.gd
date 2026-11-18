extends VehicleBody3D

@onready var head: Node3D = $Head
@onready var cab_camera: Camera3D = $Head/CabCamera
@onready var camera_arm: SpringArm3D = $Head/CameraArm
@onready var third_person_camera: Camera3D = $Head/CameraArm/ThirdPersonCamera
@export var lose_screen: PackedScene
@export var ui: CanvasLayer

const steer_speed: float = 1.0
const steer_diminish: float = 1.0
const speed_modifier := 1.5

const max_engine_force := [0.0, 120.0, 40.0, 30.0]
const reverse_max_force := 40.0
const brake_max := 2.0
const max_speed := [0.0, 6.0, 15.0, 100.0]

const accel := 150.0
const decel := 50.0
const brake_accel := 30.0

const SENS: float = 0.003

var gear := 1
var third_person_camera_mode: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if !global.touch_screen else Input.MOUSE_MODE_VISIBLE
	third_person_camera.current = false
	cab_camera.current = true
	global.going = true
	
	
func _input(event: InputEvent) -> void:
	#region camera movement
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if !third_person_camera_mode:
			head.rotate_y(-event.relative.x * SENS)
			cab_camera.rotate_x(-event.relative.y * SENS)
			rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))
		else:
			head.rotate_y(-event.relative.x * SENS)
			camera_arm.rotate_x(-event.relative.y * SENS)
			rotation.x = clamp(rotation.x, deg_to_rad(-45), deg_to_rad(90))
			
	#endregion
	
	if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and !global.touch_screen:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif Input.is_action_just_pressed("escape_key") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("restart"):
		global.time_played = 0.0
		var title_screen: Control
		if !global.two_player:
			title_screen = get_parent().get_parent()
		else:
			title_screen = get_parent().get_parent().get_parent().get_parent().get_parent()
		if get_tree():
			title_screen.restart()
		else:
			return
	elif event.is_action_pressed("upshift"):
		gear -= 1
		gear = clamp(gear, 0, 3)
	elif  event.is_action_pressed("downshift"):
		gear += 1
		gear = clamp(gear, 0, 3)
	elif global.touch_screen:
		gear = global.gear
	elif event.is_action_pressed("back_to_title"):
		var title_screen: Control
		if !global.two_player:
			title_screen = get_parent().get_parent()
		else:
			title_screen = get_parent().get_parent().get_parent().get_parent().get_parent()
		title_screen.back_to_title()

func _physics_process(delta: float) -> void:
	var target_force := 0.0
	var target_brake := 0.0
	var forward_speed := linear_velocity.dot(-global_transform.basis.z)
	
	#region check collisions
	var colliding_bodies = get_colliding_bodies()
	for body in colliding_bodies:
		if body.is_in_group("cops"):
			if global.two_player:
				get_parent().get_parent().get_parent().get_parent().get_parent().lose()
			else:
				get_parent().get_parent().lose()
	#endregion
	
	if forward_speed > 7.0:
		global.debug_message = "Don't let those cops catch you!"
	
	if Input.is_action_just_pressed("camera_toggle"):
		third_person_camera_mode = !third_person_camera_mode
		cab_camera.current = !third_person_camera_mode
		third_person_camera.current = third_person_camera_mode

	if Input.is_action_pressed("gas") and forward_speed < max_speed[gear]:
		if forward_speed < -1.0:
			target_brake = brake_max
		else:
			target_force = max_engine_force[gear]
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
	
	if Input.is_action_pressed("turn_left") and !global.touch_screen:
		var steer_max := speed_modifier / linear_velocity.length()
		if steer_max > 0.6:
			steer_max = 0.6
		
		steering = move_toward(
			steering,
			steer_max,
			steer_speed*delta
		)
		
	elif Input.is_action_pressed("joy_left") and global.touch_screen:
		var turn_input = Input.get_action_strength("joy_left")
		steering = calculate_joystick_steering(turn_input, true)
		
	elif Input.is_action_pressed("turn_right") and !global.touch_screen:
		var steer_max := -speed_modifier / linear_velocity.length()
		if steer_max < -0.6:
			steer_max = -0.6
		steering = move_toward(
			steering,
			steer_max,
			steer_speed*delta
		)
	elif Input.is_action_pressed("joy_right") and global.touch_screen:
		var turn_input = Input.get_action_strength("joy_right")
		steering = calculate_joystick_steering(turn_input, false)
		
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
			
func _process(_delta: float) -> void:
	if !global.touch_screen:
		global.gear = gear
	global.player_position = global_position
	
func calculate_joystick_steering(turn_input: float, left: bool) -> float:
	var deadzone: float = 0.1
	
	if turn_input < deadzone:
		return 0.0
	
	var speed: float = linear_velocity.length()
	var steer_max: float = 0.6
	if speed > 0.01:
		steer_max = min(0.6, speed_modifier / speed)
	
	var final_steer: float = min(turn_input, steer_max)
	return final_steer if left else -final_steer
