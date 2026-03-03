class_name BasicSlime
extends Enemy

@export var gravity: float = 800.0
@export var speed: float = 30.0

@export var time_between_jumps: float = 5.0
@export var target_distance_from_player: float = 75

@onready var vision: Area2D = %Vision
@onready var jump_timer: Timer = %JumpTimer

var player: Player
var starting_pos: Vector2

var position_padding: float = 1.0

## If the player is within the vision Area2D
var player_is_visible: bool = false:
	set = set_player_is_visible
## If we are in the middle of jumping
var is_jumping: bool = false


func _ready() -> void:
	super._ready()
	starting_pos = position
	jump_timer.wait_time = time_between_jumps
	position.x += 100
	#position.y -= 100


func _process(delta: float) -> void:
	super._process(delta)
	_check_if_player_visible()
	
	_handle_gravity(delta)
	
	if player_is_visible:
		_go_to_player()
	else:
		_go_to_starting_pos()
	
	move_and_slide()


## Applies gravity
func _handle_gravity(delta: float) -> void:
	velocity.y += gravity * delta


## Sets player_is_visible to true or false
## Also sets player if setting player_is_visible to true
func _check_if_player_visible() -> void:
	for body in vision.get_overlapping_bodies():
		if body is Player:
			player = body
			player_is_visible = true
			return
	
	player_is_visible = false


## Makes the slime go towards where it started
func _go_to_starting_pos() -> void:
	_go_to_x_cor(starting_pos.x)


## Makes the slime try to go to target_distance_from_player away from the player
func _go_to_player() -> void:
	var target_x: float
	
	if position.x < player.position.x:
		target_x = player.position.x - target_distance_from_player
	else:
		target_x = player.position.x + target_distance_from_player
	
	_go_to_x_cor(target_x)


## Makes the slime go to the target_x coordinate
func _go_to_x_cor(target_x: float) -> void:
	if target_x + position_padding < position.x:
		velocity.x = -speed
	
	elif position.x < target_x - position_padding:
		velocity.x = speed
	
	else:
		velocity.x = 0
		position.x = target_x


func set_player_is_visible(new_value: bool) -> void:
	# do nothing if it isn't changing
	if player_is_visible == new_value:
		return
	
	assert(player != null, "Did not set player before making player_is_visible true")
	
	# start or stop the timer if the player is visible
	if new_value:
		jump_timer.start()
	else:
		jump_timer.stop()
	
	player_is_visible = new_value
