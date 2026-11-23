extends Node3D

@export var cop: PackedScene
var cars_spawned: int = 1
@onready var player: VehicleBody3D = $"../../VehicleBody3D"
@export var max_cars: int = 40

func _ready() -> void:
	spawn_car()

func spawn_car() -> void:
	var x: float
	var z: float
	while true:
		x = randi_range(-3, -1)*32 if randi_range(0,1) == 1 else randi_range(1, 3)*32
		z = randi_range(-3, -1)*32 if randi_range(0,1) == 1 else randi_range(1, 3)*32
		break
		
	var cop_car = cop.instantiate()
	add_child(cop_car)
	cop_car.global_position = Vector3(global.player_position.x - x, 5.0, global.player_position.z - z)
	
func _process(delta: float) -> void:
	if round(global.time_played / cars_spawned) >= 3 and cars_spawned < max_cars:
		cars_spawned += 1
		spawn_car()
		
		if cars_spawned == max_cars:
			var cinco = get_node("%TextureRect5")
			cinco.visible = true
		elif cars_spawned >= max_cars * 0.75: #3/4
			var cuatro = get_node("%TextureRect4")
			cuatro.visible = true
		elif cars_spawned >= max_cars * 0.5: #2/4
			var tres = get_node("%TextureRect3")
			tres.visible = true
		elif cars_spawned >= max_cars * 0.25: #1/4
			var dos = get_node("%TextureRect2")
			dos.visible = true
		
		
