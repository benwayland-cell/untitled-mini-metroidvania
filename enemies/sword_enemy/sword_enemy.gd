class_name SwordEnemy
extends Enemy

## Behavior:
## When the player isn't visible, it goes to starting_pos
## When visible, it starts by aproaching the player
## When it is close enough, it starts to windup, and then attack
## It then runs away and loops back

@export_group("Base Stats")
@export var health: int = 2

@export_group("Speed")
@export var default_speed: float = 30.0
@export var approaching_speed: float = 50.0
@export var flee_speed: float = 100.0

@export_group("Spacing")
@export var distance_when_approaching: float = 20.0

@export_group("Timing")
@export var windup_time: float = 0.5
@export var sword_active_time: float = 0.5
@export var flee_time: float = 2.0

@onready var sword: Area2D = %Sword
@onready var attack_range: Area2D = %AttackRange
@onready var timer: Timer = %Timer

enum State {DEFAULT, APPROACHING, WINDUP, ATTACKING, FLEEING}
var state: State:
	set = _set_state


func _ready() -> void:
	super._ready()
	_health = health
	state = State.DEFAULT


func _process(delta: float) -> void:
	super._process(delta)
	
	_run_state_process()
	
	move_and_slide()


func _set_state(new_state: State) -> void:
	state = new_state
	
	# cleaning up at the top of a state
	timer.stop()
	sword.visible = false
	
	match state:
		State.DEFAULT:
			_default_ready()
		State.APPROACHING:
			_approaching_ready()
		State.WINDUP:
			_windup_ready()
		State.ATTACKING:
			_attacking_ready()
		State.FLEEING:
			_fleeing_ready()


func _run_state_process() -> void:
	match state:
		State.DEFAULT:
			_default_process()
		State.APPROACHING:
			_approaching_process()
		State.WINDUP:
			_windup_process()
		State.ATTACKING:
			_attacking_process()
		State.FLEEING:
			_fleeing_process()


func _on_timer_timeout() -> void:
	match state:
		State.WINDUP:
			_on_windup_timer_timeout()
		State.ATTACKING:
			_on_attacking_timer_timeout()
		State.FLEEING:
			_on_fleeing_timer_timeout()


################    Default

func _default_ready() -> void:
	current_speed = default_speed


func _default_process() -> void:
	go_to_x_cor(starting_pos.x)
	
	if player_is_visible:
		state = State.APPROACHING


################    Aproaching

func _approaching_ready() -> void:
	current_speed = approaching_speed


func _approaching_process() -> void:
	go_to_x_cor(get_player_offset_pos(distance_when_approaching))
	
	# check if we're close enough to the player to attack
	for body in attack_range.get_overlapping_bodies():
		if body is Player:
			state = State.WINDUP


################    Windup

func _windup_ready() -> void:
	current_speed = 0
	velocity.x = 0
	
	# wait for 'windup_time' seconds and go into attacking
	timer.wait_time = windup_time
	timer.start()



func _windup_process() -> void:
	pass


func _on_windup_timer_timeout() -> void:
	state = State.ATTACKING


################    Attacking

func _attacking_ready() -> void:
	current_speed = 0
	velocity.x = 0
	
	# init sword
	sword.visible = true
	if position.x < player.position.x:
		sword.position.x = abs(sword.position.x)
		sword.scale.x = 1
	else:
		sword.position.x = -abs(sword.position.x)
		sword.scale.x = -1
	
	timer.wait_time = sword_active_time
	timer.start()


func _attacking_process() -> void:
	# kill the player if they are in the sword
	for body in sword.get_overlapping_bodies():
		if body is Player:
			body.kill()


func _on_attacking_timer_timeout() -> void:
	state = State.FLEEING


################    Fleeing


func _fleeing_ready() -> void:
	current_speed = flee_speed
	
	timer.wait_time = flee_time
	timer.start()


func _fleeing_process() -> void:
	# go away from the player
	if position.x < player.position.x:
		velocity.x = -current_speed
	else:
		velocity.x = current_speed


func _on_fleeing_timer_timeout() -> void:
	state = State.APPROACHING
