extends Control

@export var level: PackedScene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape_key"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_start() -> void:
	for child in get_children():
		child.visible = false
	var level1 = level.instantiate()
	add_child(level1)
	return

func restart() -> void:
	var main: Node3D = get_node_or_null("main")
	if !main:
		return
		
	remove_child(main)
	main.queue_free()

	var level1 = level.instantiate()
	add_child(level1)
	
func back_to_title() -> void:
	var main: Node3D = get_node_or_null("main")
	if !main:
		return
	remove_child(main)
	main.queue_free()
	for child in get_children():
		child.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
