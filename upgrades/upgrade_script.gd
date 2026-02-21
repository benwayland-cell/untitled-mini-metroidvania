@abstract
class_name UpgradeClass
extends CharacterBody2D

const INITIAL_VELOCITY = 100
const GRAVITY: int= 500
const BOUNCE_LOSS_FACTOR: float= 0.9

@export var area2D: Area2D

func _ready() -> void:
	velocity.y = -INITIAL_VELOCITY

func _physics_process(delta: float) -> void:
	_check_for_player_collision()
	_update_movement(delta)


func _check_for_player_collision() -> void:
	for body in area2D.get_overlapping_bodies():
		if body is Player:
			update_player(body)
			queue_free()


func _update_movement(delta: float) -> void:
	velocity.y += GRAVITY * delta
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		velocity.y *= BOUNCE_LOSS_FACTOR


func update_player(player_to_update: Player) -> void:
	assert(false, str(player_to_update))
