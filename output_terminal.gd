extends WireTerminal
class_name OutputTerminal

func _ready():
	super()
	if !component: return
	component.output_sent.connect(recieve_input)

func recieve_input(value : int, _from : Node = null):
	output_sent.emit(value,self)
