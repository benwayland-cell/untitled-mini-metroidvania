extends Node2D
class_name WireTerminal

var component : WiringComponent = null

func _ready():
	var parent = get_parent()
	if parent is WiringComponent: 
		component = parent
	else: 
		push_warning("Parent mush be wiring component to work.")
		queue_free()
		return

func recieve_input(_value : int, _from : Node = null):
	pass

signal output_sent()
