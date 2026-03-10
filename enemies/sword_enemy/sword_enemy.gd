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

@export_group("Squash and Stretch")
# used by squash and stretch
@export var squash_speed: float = 2.0
@export var unsquash_speed: float = 5.0
@export var squash_stretch_amount: float = 0.5


@onready var sprite: Sprite2D = %Sprite2D
@onready var eye_sprite: Sprite2D = %EyeSprite
@onready var sword: Area2D = %Sword
@onready var attack_range: Area2D = %AttackRange
@onready var timer: Timer = %Timer


enum State {DEFAULT, APPROACHING, WINDUP, ATTACKING, FLEEING}
var state: State:
	set = _set_state

# eye animation
const EYE_SPEED: float = 50.0
const EYE_LEFT_POS: float = -3
const EYE_RIGHT_POS: float = 3
const EYE_MIDDLE_POS: float = 0
@onready var target_eye_pos := eye_sprite.position

var squashed_vector: Vector2 = Vector2(1 + squash_stretch_amount, 1 - squash_stretch_amount)


func _ready() -> void:
	super._ready()
	_health = health
	state = State.DEFAULT


func _process(delta: float) -> void:
	super._process(delta)
	
	_handle_eye_animation(delta)
	_run_state_process(delta)
	
	move_and_slide()


func _handle_eye_animation(delta: float):
	if velocity.x > 0:
		target_eye_pos.x = EYE_RIGHT_POS
	elif velocity.x < 0:
		target_eye_pos.x = EYE_LEFT_POS
	
	eye_sprite.position = eye_sprite.position.move_toward(target_eye_pos, EYE_SPEED * delta)



################    States


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


func _run_state_process(delta: float) -> void:
	match state:
		State.DEFAULT:
			_default_process()
		State.APPROACHING:
			_approaching_process()
		State.WINDUP:
			_windup_process(delta)
		State.ATTACKING:
			_attacking_process(delta)
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



func _windup_process(delta) -> void:
	# squash
	sprite.scale = sprite.scale.move_toward(squashed_vector, squash_speed * delta)


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


func _attacking_process(delta: float) -> void:
	# kill the player if they are in the sword
	for body in sword.get_overlapping_bodies():
		if body is Player:
			body.kill()
	
	# unsquash from winding up
	sprite.scale.x = move_toward(sprite.scale.x, 1, unsquash_speed * delta)
	sprite.scale.y = move_toward(sprite.scale.y, 1, unsquash_speed * delta)


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
