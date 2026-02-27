@abstract
class_name Enemy
extends CharacterBody2D

signal died


@export var drop: PackedScene = null
@export var health: int = 1
@export var invincibility_time: float = 0.5

@export_group("Private Nodes")
@export var hurt_box: Area2D

var invinciblity_timer: Timer = Timer.new()
var invincible: bool = false


func _ready() -> void:
	invinciblity_timer.wait_time


func _process(_delta: float) -> void:
	if invincible:
		return
	
	for body in hurt_box.get_overlapping_bodies():
		if body is Player:
			body.kill()


func take_damage(damage_amount: int, player: Player) -> void:
	health -= damage_amount
	
	if Input.is_action_pressed("down") and player.global_position.y < global_position.y:
		player.jump()
		player.can_double_jump = true
	
	if health <= 0:
		died.emit()
		if drop != null:
			var drop_scene : Node2D = drop.instantiate()
			add_sibling(drop_scene)
			drop_scene.global_position = global_position
			
			if drop_scene is UpgradeClass:
				drop_scene.give_velocity()
		
		queue_free()
