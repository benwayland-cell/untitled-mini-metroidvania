@abstract
class_name Enemy
extends CharacterBody2D

signal died

@export var drop: PackedScene = null

@export_group("Damage")
@export var _health: int = 1
@export var invincibility_time: float = 0.5

@export_group("Movement")
@export var gravity: float = 800.0

@export_group("Private Nodes")
@export var hurt_box: Area2D
@export var vision: Area2D
@export var highlight: Sprite2D

@onready var visibility_ray := RayCast2D.new()

var starting_pos: Vector2
var position_padding: float = 1.0

var player: Player
var last_seen_player_pos: Vector2

var current_speed: float = 50.0

var invinciblity_timer: Timer = Timer.new()
var invincible: bool = false

## If the player is within the vision Area2D
var player_is_visible: bool = false
var _player_is_in_vision: bool = false


func _ready() -> void:
	assert(hurt_box != null, "Forgot to initialize hurt box in: " + name)
	assert(highlight != null, "Didn't initialize highlight in: " + name)
	
	starting_pos = position
	add_child(visibility_ray)
	
	invinciblity_timer.wait_time = invincibility_time
	invinciblity_timer.one_shot = true
	invinciblity_timer.timeout.connect(_on_invinciblity_timer_timeout)
	add_child(invinciblity_timer)
	
	if drop != null:
		highlight.show()


func _process(delta: float) -> void:
	_check_if_player_visible()
	_handle_gravity(delta)
	
	if player_is_visible:
		last_seen_player_pos = player.position
	
	for body in hurt_box.get_overlapping_bodies():
		if body is Player:
			body.kill()


func take_damage(damage_amount: int, damaging_object: Node) -> void:
	#don't take damage if it is currently invincible
	if invincible:
		return
	
	_health -= damage_amount
	
	invincible = true
	modulate.a = 0.5
	invinciblity_timer.start()
	
	if damaging_object is Player:
		if Input.is_action_pressed("down") and damaging_object.global_position.y < global_position.y:
			damaging_object.jump()
			damaging_object.can_double_jump = true
	
	if _health <= 0:
		died.emit()
		if drop != null:
			var drop_scene : Node2D = drop.instantiate()
			add_sibling(drop_scene)
			drop_scene.global_position = global_position
			
			if drop_scene is UpgradeClass:
				drop_scene.give_velocity()
		
		queue_free()


## Applies gravity
func _handle_gravity(delta: float) -> void:
	velocity.y += gravity * delta


## Makes the enemy go to the target_x coordinate
func go_to_x_cor(target_x: float) -> void:
	if target_x + position_padding < position.x:
		velocity.x = -current_speed
	
	elif position.x < target_x - position_padding:
		velocity.x = current_speed
	
	else:
		velocity.x = 0
		position.x = target_x


## Sets player_is_visible to true or false
## Also sets player if setting player_is_visible to true
func _check_if_player_visible() -> void:
	# if the player is in visions, check if there is a line of sight
	player_is_visible = false
	if _player_is_in_vision and player != null:
		player_is_visible = not visibility_ray.is_colliding()
		visibility_ray.target_position = player.position - position
	
	# check if the player is in vision
	_player_is_in_vision = false
	for body in vision.get_overlapping_bodies():
		if body is Player:
			player = body
			_player_is_in_vision = true
			# make the ray point to the player
			visibility_ray.target_position = player.position - position
	


## Gets a vector from the enemy to the player
func get_distance_from_player() -> Vector2:
	assert(player != null, "Player was null when get_distance_from_player was called")
	return player.position - position


## Returns the x coordinate that is 'offset' distance from player
## Gives the coordinate on the side that is closer
func get_player_offset_pos(offset: float) -> float:
	if position.x < player.position.x:
		return player.position.x - offset
	else:
		return player.position.x + offset


func _on_invinciblity_timer_timeout() -> void:
	modulate.a = 1.0
	invincible = false
	show()
