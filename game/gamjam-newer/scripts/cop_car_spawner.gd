extends Node3D

@export var cop: PackedScene
var cars_spawned: int = 1
@onready var player: VehicleBody3D = $"../../VehicleBody3D"

func _ready() -> void:
	spawn_car()

func spawn_car() -> void:
	var x: float
	var z: float
	while true:
		x = randi_range(-5, 5)*32
		z = randi_range(-5, 5)*32
		var x_dist = abs(player.global_position.x - x)
		var z_dist = abs(player.global_position.z - z)
		if (x_dist > 32.0 and z_dist > 32.0) and (x_dist < 75.0 and z_dist < 75.0):
			break
		
	var cop_car = cop.instantiate()
	add_child(cop_car)
	cop_car.global_position = Vector3(x, 5.0, z)
	
func _process(delta: float) -> void:
	if round(global.time_played / cars_spawned) >= 1 and cars_spawned < 25:
		cars_spawned += 1
		spawn_car()
		
		
