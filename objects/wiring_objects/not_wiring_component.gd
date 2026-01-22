extends WiringComponent
class_name NotWiringComponent

@export var true_output_value : float = 1.0

var output_on_ready : bool = true
func _ready() -> void:
	super()
	if output_on_ready: output_value = true_output_value

func recieve_input(value : float, _from : Wire):
	output_on_ready = false
	if value: output_value = 0
	else: output_value = true_output_value
