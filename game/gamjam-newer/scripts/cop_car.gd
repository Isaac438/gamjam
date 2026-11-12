extends VehicleBody3D

@export var nav_agent: NavigationAgent3D

var t := 0.0
func _process(delta: float) -> void:
	t += delta
	if t > 1.0:
		t = 0.0
		nav_agent.target_position = global.player_position
	
	global_position.x = move_toward(global_position.x, nav_agent.get_next_path_position().x, delta)
	global_position.z = move_toward(global_position.z, nav_agent.get_next_path_position().z, delta)
	
