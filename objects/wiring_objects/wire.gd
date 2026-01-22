@tool
extends Line2D
class_name Wire

@export var output : OutputTerminal = null
@export var input : InputTerminal = null

func _ready():
	#code runs in editor
	if Engine.is_editor_hint(): 
		while points.size() < 2: points.append(Vector2.ZERO)
		return
	
	set_process(false)
	output.output_sent.connect(recieve_input)
	output.output_sent.connect(input.recieve_input)

func recieve_input(value : int, _from : Node = null):
	default_color = Color(1,1,1)*value

func _process(_delta):
	if !Engine.is_editor_hint(): return
	#code runs in editor
	position = Vector2.ZERO
	if output: points[0] = output.global_position
	if input: points[1] = input.global_position
	

func _set(property: StringName, _value: Variant) -> bool:
	match property:
		"points":
			points = [Vector2.ZERO,Vector2.ZERO]
			return true
	return false
