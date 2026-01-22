extends WiringComponent
class_name PowerComponent

func _ready() -> void:
	output_sent.emit(1)
