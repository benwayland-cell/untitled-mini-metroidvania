extends CharacterBody2D
class_name Player

signal player_killed

@export var jump_grav :int= 1500
@export var fall_grav :int= 2500
@export var speed :int= 10000
@export var jump_velocity :int= 500
@export var min_jump_velocity :int= 0

@export var sword_cooldown_time :float= 0.1

@export var dash_velocity :int= 800
@export var dash_time :float= 0.1
@export var dash_cooldown :float= 0.2

@onready var sprite: Sprite2D = %PlayerSprite

var disabled: bool = false


# abililities unlocked
var has_sword :bool= false
var has_double_jump_ability :bool= false
var has_dash :bool= false

enum PlayerState {ON_GROUND, JUMPING, FALLING, DASHING}
enum PlayerLeftRight {LEFT, RIGHT}

var player_state := PlayerState.ON_GROUND
var player_left_right_state := PlayerLeftRight.RIGHT
var left_right_direction :int= 0

var sword_cooldown_done :bool= true
var sword_offset : Vector2
var can_double_jump :bool= true
var can_dash :bool= true
var dash_time_done :bool= true
var dash_cooldown_done :bool= true

var sprite_frame_as_float: float


func _ready() -> void:
	sprite_frame_as_float = sprite.frame
	sword_offset = %Sword.position


func _process(delta: float) -> void:
	if disabled:
		return
	
	_update_player_state()
	_handle_jumping()
	_handle_left_right(delta)
	_handle_grav(delta)
	_handle_sword()
	_handle_dash(delta)
	_handle_animation(delta)
	_handle_debug()
	
	%Sword.get_overlapping_bodies()
	
	move_and_slide()


func _handle_animation(delta: float) -> void:
	_handle_sword_animation()
	_handle_eye_movement(delta)


func _handle_sword_animation() -> void:
	# flip the sword's position depending on which way we're going
	if (%Sword.visible): # don't change it when it's visible
		return
	
	if Input.is_action_pressed("down"):
		%Sword.position = Vector2(0, sword_offset.x)
		%Sword.rotation = deg_to_rad(90)
	elif player_left_right_state == PlayerLeftRight.LEFT:
		%Sword.position = -sword_offset
		%Sword.rotation = 0
	elif player_left_right_state == PlayerLeftRight.RIGHT:
		%Sword.position = sword_offset
		%Sword.rotation = 0


# note that this assumes 8 frames
func _handle_eye_movement(delta: float) -> void:
	const FAST_SPEED: float = 50
	const SLOW_SPEED: float = 25
	
	var target_frame: float
	var frame_speed: float
	
	if Input.is_action_pressed("right"):
		target_frame = 7
		frame_speed = FAST_SPEED
	elif Input.is_action_pressed("left"):
		target_frame = 0
		frame_speed = FAST_SPEED
	elif player_left_right_state == PlayerLeftRight.LEFT:
		target_frame = 3
		frame_speed = SLOW_SPEED
	elif player_left_right_state == PlayerLeftRight.RIGHT:
		target_frame = 4
		frame_speed = SLOW_SPEED
	else:
		target_frame = sprite.frame
		frame_speed = 0
	
	if sprite.frame == int(target_frame):
		sprite_frame_as_float = sprite.frame
		return
	
	if sprite_frame_as_float < target_frame:
		sprite_frame_as_float += frame_speed * delta
		print(frame_speed * delta)
		sprite_frame_as_float = min(sprite_frame_as_float, target_frame)
		
	else:
		sprite_frame_as_float -= frame_speed * delta
		sprite_frame_as_float = max(sprite_frame_as_float, target_frame)
	
	sprite.frame = int(sprite_frame_as_float)


func _update_player_state() -> void:
	# stay dashing if we are currently dashing
	if player_state == PlayerState.DASHING and not dash_time_done and not is_on_wall():
		return
	
	if (is_on_floor()):
		player_state = PlayerState.ON_GROUND
		can_double_jump = true
	
	# if the player has let go of the jump button and has reached the min_jump_velocity
	# or they are falling
	elif ((velocity.y < -min_jump_velocity and not Input.is_action_pressed("jump")) or velocity.y >= 0):
		player_state = PlayerState.FALLING


func _handle_left_right(delta: float) -> void:
	if player_state == PlayerState.DASHING:
		return
	
	left_right_direction = 0
	
	if Input.is_action_pressed("left"):
		left_right_direction += -1
	if Input.is_action_pressed("right"):
		left_right_direction += 1
	
	velocity.x = left_right_direction * delta * speed
	
	# handle player_left_right_state
	if left_right_direction == -1:
		player_left_right_state = PlayerLeftRight.LEFT
	elif left_right_direction == 1:
		player_left_right_state = PlayerLeftRight.RIGHT


func _handle_jumping() -> void:
	# check if we can jump
	var can_jump :bool= false
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			can_jump = true
		elif has_double_jump_ability and can_double_jump:
			can_jump = true
			can_double_jump = false
	
	if not can_jump:
		return
	
	jump()


func jump() -> void:
	velocity.y = -jump_velocity
	player_state = PlayerState.JUMPING


func _handle_grav(delta: float) -> void:
	if player_state == PlayerState.DASHING:
		return
	elif player_state == PlayerState.JUMPING:
		velocity.y += jump_grav * delta
	else:
		velocity.y += fall_grav * delta


func _handle_sword() -> void:
	if not (Input.is_action_just_pressed("attack") and has_sword and sword_cooldown_done):
		return
	
	#swing the sword
	sword_cooldown_done = false
	%Sword.show()
	for body in %Sword.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			body.take_damage(1, self)
	
	# wait until the sword should be hidden
	await get_tree().create_timer(0.1).timeout
	%Sword.hide()
	
	await get_tree().create_timer(sword_cooldown_time).timeout
	sword_cooldown_done = true


func _handle_dash(_delta: float) -> void:
	# allow us to dash 
	if dash_cooldown_done and is_on_floor():
		can_dash = true
	
	if not (Input.is_action_just_pressed("dash") and can_dash and has_dash):
		return
	
	# start dashing
	player_state = PlayerState.DASHING
	can_dash = false
	if player_left_right_state == PlayerLeftRight.LEFT:
		velocity = Vector2(-1 * dash_velocity, 0)
	elif player_left_right_state == PlayerLeftRight.RIGHT:
		velocity = Vector2(dash_velocity, 0)
	
	# wait for the dash to be done
	dash_time_done = false
	await get_tree().create_timer(dash_time).timeout
	dash_time_done = true
	
	# wait for the dash cooldown to be done
	dash_cooldown_done = false
	await get_tree().create_timer(dash_cooldown).timeout
	dash_cooldown_done = true


func _handle_debug() -> void:
	if Input.is_action_just_pressed("debug 1"):
		has_sword = !has_sword
		print("Sword: " + str(has_sword))
	
	if Input.is_action_just_pressed("debug 2"):
		has_double_jump_ability = !has_double_jump_ability
		print("Double jump: " + str(has_double_jump_ability))
	
	if Input.is_action_just_pressed("debug 3"):
		has_dash = !has_dash
		print("Dash: " + str(has_dash))


func kill() -> void:
	player_killed.emit()
