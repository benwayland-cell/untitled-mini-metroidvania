@tool
extends Line2D
class_name Wire

@export var output : WiringComponent = null
@export var input : WiringComponent = null

func _ready():
	#code runs in editor
	if Engine.is_editor_hint(): 
		width = 1.0
		points = [Vector2.ZERO,Vector2.ZERO]
		default_color = Color.BLACK
		set_meta("_edit_lock_", true)
		return
	
	set_process(false)
	
	output.output_sent.connect(recieve_input)
	output_sent.connect(input.recieve_input)
	
	if output.output_value != 0: recieve_input(output.output_value)

#var carrying_value : float = 0.0

func recieve_input(value : float):
	#carrying_value = value
	default_color = Color(1,1,1)*value
	default_color.a = 1.0
	output_sent.emit(value, self)

signal output_sent()

func _process(_delta):
	if !Engine.is_editor_hint(): return
	#code runs in editor
	
	position = Vector2.ZERO
	if output: points[0] = output.output_position_node.global_position if output.output_position_node else output.global_position
	if input: points[1] = input.input_position_node.global_position if input.input_position_node else input.global_position
	

func _set(property: StringName, _value: Variant) -> bool:
	match property:
		"points":
			points = [Vector2.ZERO,Vector2.ZERO]
			return true
	return false
