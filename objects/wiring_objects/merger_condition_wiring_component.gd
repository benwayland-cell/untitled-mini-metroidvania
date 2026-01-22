extends WiringComponent
class_name MergerConditionWiringComponent

var total_value : float = 0.0
@export var comparison_value : float = 2.0
@export_enum("greater","greater_equal","equal","less_equal","less") var condition = "greater_equal"
@export var override_output_value : float = 0.0

func recieve_input(value : float, _from : Wire):
	total_value += value
	match condition:
		"greater":
			if total_value > comparison_value: 
				output_value = total_value
				return
		"greater_equal":
			if total_value >= comparison_value: 
				output_value = total_value
				return
		"equal":
			if total_value == comparison_value: 
				output_value = total_value
				return
		"less_equal":
			if total_value <= comparison_value: 
				output_value = total_value
				return
		"less":
			if total_value < comparison_value: 
				output_value = total_value
				return
	output_value = 0.0

func prep_output():
	if override_output_value: output_value = override_output_value
	output_value = total_value
