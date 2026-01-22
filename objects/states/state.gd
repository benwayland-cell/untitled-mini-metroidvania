extends Node
class_name State

@export var enter_on_ready : bool = false
var entered_parent : Node = null

# prepares state
func _ready():
	var parent = get_parent()
	await parent.ready
	if enter_on_ready:
		enter()
	else:
		set_process(false)

# state starts
func enter():
	entered_parent = get_parent()
	set_process(true)

# state gets a friend
func enter_parallel(parallel_state : State):
	parallel_state.enter()

# state ends (with optional successor state)
func exit(successor : State = null):
	if successor: successor.enter()
	
	entered_parent = null
	set_process(false)

# state updates
func do_state(_delta : float):
	pass

func _process(delta : float):
	do_state(delta)
