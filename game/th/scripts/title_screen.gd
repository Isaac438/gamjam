extends Control

@export var level: PackedScene
@export var level2p: PackedScene
@export var lose_screen: PackedScene
@export var tutorial_screen: PackedScene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape_key"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	for child in get_children():
		child.visible = true

func _on_start() -> void:
	for child in get_children():
		child.visible = false
	
	if !global.two_player:
		var level1 = level.instantiate()
		add_child(level1)
	else:
		var level1 = level2p.instantiate()
		add_child(level1)
	return

func restart() -> void:
	global.time_played = 0.0
	var main: Node3D = get_node_or_null("main")
	if main:
		remove_child(main)
		main.queue_free()
	if !global.two_player:
		var level1 = level.instantiate()
		add_child(level1)
	else:
		var level1 = level2p.instantiate()
		add_child(level1)
	
func back_to_title() -> void:
	var main: Node3D = get_node_or_null("main")
	if main:
		remove_child(main)
		main.queue_free()
	for child in get_children():
		child.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func tutorial() -> void:
	for child in get_children():
		child.visible = false
	var tutorial1 = tutorial_screen.instantiate()
	add_child(tutorial1)

func lose() -> void:
	var lose_screen1 = lose_screen.instantiate()
	add_child(lose_screen1)
	var main: Node3D = get_node_or_null("main")
	if !main:
		return
	remove_child(main)
	main.queue_free()
	
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("back_to_title"):
			remove_child(lose_screen1)
			lose_screen1.queue_free()
			for child in get_children():
				child.visible = false
			back_to_title()
			return
		elif Input.is_action_just_pressed("restart"):
			remove_child(lose_screen1)
			lose_screen1.queue_free()
			for child in get_children():
				child.visible = false
			restart()
			return
