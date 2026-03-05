class_name BasicSlime
extends Enemy

@export var health: int = 1
@export var speed: float = 30.0
@export var time_between_jumps: float = 1
@export var target_distance_from_player: float = 75

@export var jump_vector := Vector2(200, -200)

@onready var jump_timer: Timer = %JumpTimer

## If we are in the middle of jumping
var is_jumping: bool = false:
	set = _set_is_jumping

var was_airbourne: bool = false


func _ready() -> void:
	super._ready()
	current_speed = speed
	_health = health
	
	jump_timer.wait_time = time_between_jumps
	jump_timer.timeout.connect(_on_jump_timer_timeout)


func _process(delta: float) -> void:
	super._process(delta)
	
	if is_jumping:
		if is_on_floor() and was_airbourne:
			is_jumping = false
	else:
		_handle_x_velocity()
	
	move_and_slide()
	
	was_airbourne = is_jumping


func _handle_x_velocity() -> void:
	if player_is_visible:
		_go_to_player()
	else:
		_go_to_starting_pos()


## Makes the slime go towards where it started
func _go_to_starting_pos() -> void:
	go_to_x_cor(starting_pos.x)


## Makes the slime try to go to target_distance_from_player away from the player
func _go_to_player() -> void:
	go_to_x_cor(get_player_offset_pos(target_distance_from_player))


func set_player_is_visible(new_value: bool) -> void:
	# do nothing if it isn't changing
	if player_is_visible == new_value:
		return
	
	# start or stop the timer if the player is visible
	if new_value:
		jump_timer.start()
	else:
		jump_timer.stop()
	
	player_is_visible = new_value


## Jumps if set to true
func _set_is_jumping(new_value: bool) -> void:
	if new_value == is_jumping:
		return
	is_jumping = new_value
	
	if not is_jumping:
		jump_timer.start()
		return
	
	if position.x < player.position.x:
		velocity = jump_vector
	else:
		velocity = Vector2(-jump_vector.x, jump_vector.y)


func _on_jump_timer_timeout() -> void:
	is_jumping = true
