extends VBoxContainer

@export var N : Label
@export var First: Label
@export var Second: Label
@export var Third: Label

var gears: Array[Label]
var gear := 1

func _ready() -> void:
	gears = [N, First, Second, Third]
	
func _process(delta: float) -> void:
	if global.gear != gear:
		gears[gear].modulate = Color(1, 1, 1, 1)
		gear = global.gear
		gears[gear].modulate = Color("ababab")
