extends Node3D

@export var building: PackedScene
@export var grass: PackedScene
@export var tree: PackedScene
@export var loading_screen: PackedScene
@export var road: PackedScene
@export var road_center: PackedScene
@export var park_floor: PackedScene
@export var ui: CanvasLayer

func make_block(x: float, z: float) -> void:
	#geneate corners
	var road_center1 = road_center.instantiate()
	add_child(road_center1)
	if !is_overlapping(road_center1):
		road_center1.global_position = Vector3(x, 0, z)
	else:
		road_center1.queue_free()
	var road_center2 = road_center.instantiate()
	add_child(road_center2)
	if !is_overlapping(road_center2):
		road_center2.global_position = Vector3(x + 32.0, 0, z)
	else:
		road_center2.queue_free()
	var road_center3 = road_center.instantiate()
	add_child(road_center3)
	if !is_overlapping(road_center3):
		road_center3.global_position = Vector3(x, 0, z + 32.0)
	else:
		road_center3.queue_free()
	var road_center4 = road_center.instantiate()
	add_child(road_center4)
	if !is_overlapping(road_center4):
		road_center4.global_position = Vector3(x + 32.0, 0, z + 32.0)
	else:
		road_center4.queue_free()
	
	#generate edges
	
	var road1 = road.instantiate()
	add_child(road1)
	if !is_overlapping(road1):
		road1.global_position = Vector3(x, 0.0, z + 16.0)
	else:
		road1.queue_free()
	var road2 = road.instantiate()
	add_child(road2)
	if !is_overlapping(road2):
		road2.global_position = Vector3(x + 16.0, 0.0, z)
		road2.set_rotation(Vector3(0.0, deg_to_rad(90.0), 0.0))
	else:
		road2.queue_free()
	var road3 = road.instantiate()
	add_child(road3)
	if !is_overlapping(road3):
		road3.global_position = Vector3(x+32.0, 0.0, z+16.0)
	else:
		road3.queue_free()
	var road4 = road.instantiate()
	add_child(road4)
	if !is_overlapping(road4):
		road4.global_position = Vector3(x+16.0, 0.0, z+32.0)
		road4.set_rotation(Vector3(0.0, deg_to_rad(90.0), 0.0))
	else:
		road4.queue_free()
		
	#generate center randomly

	if randi_range(0,1) == 0:
		var building1 = building.instantiate()
		add_child(building1)
		building1.global_position = Vector3(x+16.0, 0.0, z+16.0)
		var rand_rotate = randi_range(0,3)
		if rand_rotate == 1:
			rand_rotate = deg_to_rad(90.0)
		elif rand_rotate == 2:
			rand_rotate = deg_to_rad(180.0)
		elif rand_rotate == 3:
			rand_rotate = deg_to_rad(270.0)
		building1.set_rotation(Vector3(0.0, rand_rotate, 0.0))
	else:
		#park generation
		var park_floor1 = park_floor.instantiate()
		add_child(park_floor1)
		park_floor1.global_position = Vector3(x + 16.0, 0.0, z + 16.0)
		
		for i in range(25):
			if randi_range(0,5) == 1:
				var tree1 = tree.instantiate()
				add_child(tree1)
				tree1.global_position = Vector3(x+16.0+randf_range(-8.0, 8.0), 0.0, z+16.0+randf_range(-8.0, 8.0))
			else:
				var grass1 = grass.instantiate()
				add_child(grass1)
				grass1.global_position = Vector3(x+16.0+randf_range(-8.0, 8.0), 0.0, z+16.0+randf_range(-8.0, 8.0))
	
func _ready() -> void:
	var loading_screen1 = loading_screen.instantiate()
	ui.add_child(loading_screen1)
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	for x in range(-5, 5):
		for z in range(-5, 5):
			make_block(x*32,z*32)

	ui.remove_child(loading_screen1)
	get_parent().bake_navigation_mesh()
	
func is_overlapping(piece: Node3D):
	#fix this later
	return false
	for child in self.get_children():
		if child.global_position == piece.global_position and child != piece:
			return true
	return false
	
