extends WireTerminal
class_name InputTerminal

func _ready():
	super()
	if !component: return
	output_sent.connect(component.recieve_input)

func recieve_input(value : int, from : Node = null):
	output_sent.emit(value,from)
