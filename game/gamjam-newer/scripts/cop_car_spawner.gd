extends Node3D

@export var cop: PackedScene

func _ready() -> void:
	spawn_car(32.0, 0.0)

func spawn_car(x: float, z: float) -> void:
	var cop_car = cop.instantiate()
	add_child(cop_car)
	cop_car.global_position = Vector3(x, 5.0, z)
