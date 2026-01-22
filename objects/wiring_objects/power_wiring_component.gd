extends WiringComponent
class_name PowerWiringComponent

@export var power_output_value : float = 1.0

func _ready() -> void:
	super()
	output_value = power_output_value
