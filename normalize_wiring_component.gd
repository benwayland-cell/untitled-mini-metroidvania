extends WiringComponent
class_name NormalizeWiringComponent

func recieve_input(value : float, _from : Wire):
	output_value = 1 if (value > 0) else (-1 if (value < 0) else 0)
