extends WiringComponent
class_name DelayWiringComponent

@export var delay_time = 1.0

func recieve_input(value : float, _from : Wire):
	var timer : Timer = Timer.new()
	add_child(timer)
	timer.start(delay_time)
	await timer.timeout
	output_sent.emit(value)
