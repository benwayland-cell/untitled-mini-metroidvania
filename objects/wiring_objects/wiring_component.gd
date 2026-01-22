extends Node2D
class_name WiringComponent

var input_wires : Array[Wire] = []
var output_wires : Array[Wire] = []

func add_input_wire(wire : Wire):
	input_wires.append(wire)
func add_output_wire(wire : Wire):
	output_wires.append(wire)

var output_value : float = 0:
	set(value):
		output_value = value
		output_sent.emit(value)

@export var input_position_node : Node2D = self
@export var output_position_node : Node2D = self

func _ready():
	if !input_position_node: input_position_node = self
	if !output_position_node: output_position_node = self

func recieve_input(_value : float, _from : Wire):
	pass

signal output_sent()
