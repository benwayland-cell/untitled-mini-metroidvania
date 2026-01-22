extends WiringComponent
class_name MergerWiringComponent


var total_value : float = 0.0
@export var override_output_value : float = 0.0

func recieve_input(value : float, _from : Wire):
	total_value += value
	if total_value: output_value = override_output_value if override_output_value else total_value
