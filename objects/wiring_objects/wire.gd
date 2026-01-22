@tool
extends Line2D
class_name Wire

@export var output : WiringComponent = null
@export var input : WiringComponent = null

func _ready():
	#code runs in editor
	if Engine.is_editor_hint(): 
		while points.size() < 2: points.append(Vector2.ZERO)
		return
	
	set_process(false)
	
	output.output_sent.connect(recieve_input)
	output_sent.connect(input.recieve_input)
	output.add_output_wire(self)
	input.add_input_wire(self)
	
	if output.output_value != 0: recieve_input(output.output_value)

func recieve_input(value : int):
	default_color = Color(1,1,1)*value
	output_sent.emit(value, self)

signal output_sent()

func _process(_delta):
	if !Engine.is_editor_hint(): return
	#code runs in editor
	position = Vector2.ZERO
	if output: points[0] = output.output_position_node.global_position
	if input: points[1] = input.input_position_node.global_position
	

func _set(property: StringName, _value: Variant) -> bool:
	match property:
		"points":
			points = [Vector2.ZERO,Vector2.ZERO]
			return true
	return false
