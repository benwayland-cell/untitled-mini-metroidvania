@abstract
class_name UpgradeClass
extends CharacterBody2D

signal collected

@export var initial_velocity: float = 100.0
@export var initial_left_right_velocity: float = 300.0
@export var gravity: int = 500
@export var bounce_loss_factor: float = 0.9
@export var left_right_loss_factor: float = 0.5

enum Direction {NONE, LEFT, RIGHT}

@export var area2D: Area2D

func _physics_process(delta: float) -> void:
	_check_for_player_collision()
	_update_movement(delta)


func _check_for_player_collision() -> void:
	for body in area2D.get_overlapping_bodies():
		if body is Player:
			update_player(body)
			collected.emit()
			queue_free()


func _update_movement(delta: float) -> void:
	velocity.y += gravity * delta
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		velocity.y *= bounce_loss_factor
		velocity.x *= left_right_loss_factor

func give_velocity(direction: Direction = Direction.NONE) -> void:
	velocity.y = -initial_velocity
	
	match direction:
		Direction.LEFT:
			velocity.x = initial_left_right_velocity
		Direction.RIGHT:
			velocity.x = -initial_left_right_velocity

func update_player(player_to_update: Player) -> void:
	assert(false, str(player_to_update))
