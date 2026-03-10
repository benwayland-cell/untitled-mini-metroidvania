class_name BasicSlime
extends Enemy

@export var health: int = 1
@export var speed: float = 30.0
@export var time_between_jumps: float = 1
@export var target_distance_from_player: float = 75

@export var jump_vector := Vector2(200, -200)

@onready var sprite: Sprite2D = %Sprite2D
@onready var eye_sprite: Sprite2D = %EyeSprite
@onready var jump_timer: Timer = %JumpTimer

enum State {DEFAULT, APROACHING, JUMPING}
var state: State:
	set = _set_state

# eye animation
const EYE_SPEED: float = 50.0
const EYE_LEFT_POS: float = -3
const EYE_RIGHT_POS: float = 3
const EYE_MIDDLE_POS: float = 0

# used by squash and stretch
const UNSTRETCH_SPEED: float = 2
const SQUASH_STRETCH_AMOUNT: float = 0.5


func _ready() -> void:
	super._ready()
	current_speed = speed
	_health = health
	state = State.DEFAULT
	
	jump_timer.wait_time = time_between_jumps
	jump_timer.timeout.connect(_on_jump_timer_timeout)


func _process(delta: float) -> void:
	super._process(delta)
	
	_state_process()
	_handle_animation(delta)
	
	move_and_slide()


func _handle_animation(delta: float) -> void:
	_handle_eye_animation(delta)
	_handle_squash_and_stretch(delta)


func _handle_eye_animation(delta: float):
	# don't change anything if we can't see the player
	# or we are in the middle of jumping
	if state == State.JUMPING or not player_is_visible:
		return
	
	var target_eye_pos := Vector2(0, eye_sprite.position.y)
	
	if position.x < player.position.x:
		target_eye_pos.x = EYE_RIGHT_POS
	else:
		target_eye_pos.x = EYE_LEFT_POS
	
	eye_sprite.position = eye_sprite.position.move_toward(target_eye_pos, EYE_SPEED * delta)


func _handle_squash_and_stretch(delta: float) -> void:
	# revert to normal
	sprite.scale.x = move_toward(sprite.scale.x, 1, UNSTRETCH_SPEED * delta)
	sprite.scale.y = move_toward(sprite.scale.y, 1, UNSTRETCH_SPEED * delta)


func squash() -> void:
	sprite.scale = Vector2(1 + SQUASH_STRETCH_AMOUNT, 1 - SQUASH_STRETCH_AMOUNT)


func stretch() -> void:
	sprite.scale = Vector2(1.0 - SQUASH_STRETCH_AMOUNT, 1.0 + SQUASH_STRETCH_AMOUNT)

################    States

func _set_state(new_state: State) -> void:
	state = new_state
	
	match state:
		State.DEFAULT:
			_default_ready()
		State.APROACHING:
			_aproaching_ready()
		State.JUMPING:
			_jumping_ready()


func _state_process() -> void:
	match state:
		State.DEFAULT:
			_default_process()
		State.APROACHING:
			_aproaching_process()
		State.JUMPING:
			_jumping_process()


################    Default
## Do nothing
## When the player is visible, go into the aproaching state

func _default_ready() -> void:
	velocity.x = 0


func _default_process() -> void:
	if player_is_visible:
		state = State.APROACHING


################    Aproaching
## Go to target_distance_from_player

func _aproaching_ready() -> void:
	current_speed = speed
	jump_timer.start()


func _aproaching_process() -> void:
	go_to_x_cor(get_player_offset_pos(target_distance_from_player))


func _on_jump_timer_timeout() -> void:
	state = State.JUMPING


################    Jumping
## Start by jumping at the player and do nothing until it reaches the ground

var was_airbourne: bool

func _jumping_ready() -> void:
	stretch()
	was_airbourne = false
	
	if position.x < player.position.x:
		velocity = jump_vector
	else:
		velocity = Vector2(-jump_vector.x, jump_vector.y)


func _jumping_process() -> void:
	if is_on_floor() and was_airbourne:
		state = State.APROACHING
		squash() # give the landing impact
	else:
		was_airbourne = true
