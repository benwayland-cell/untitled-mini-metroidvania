@abstract
class_name Enemy
extends CharacterBody2D

signal died

@export var drop: PackedScene = null

@export_group("Damage")
@export var health: int = 1
@export var invincibility_time: float = 0.5

@export_group("Movement")
@export var gravity: float = 800.0
@export var speed: float = 30.0

@export_group("Private Nodes")
@export var hurt_box: Area2D
@export var vision: Area2D

var invinciblity_timer: Timer = Timer.new()
var invincible: bool = false

## If the player is within the vision Area2D
var player_is_visible: bool = false:
	set = set_player_is_visible


func _ready() -> void:
	assert(hurt_box != null, "Forgot to initialize hurt box in: " + name)
	
	invinciblity_timer.wait_time = invincibility_time


func _process(delta: float) -> void:
	_check_if_player_visible()
	_handle_gravity(delta)
	
	if invincible:
		return
	
	for body in hurt_box.get_overlapping_bodies():
		if body is Player:
			body.kill()


func take_damage(damage_amount: int, damaging_object: Node) -> void:
	health -= damage_amount
	
	if damaging_object is Player:
		var player: Player = damaging_object
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


## Applies gravity
func _handle_gravity(delta: float) -> void:
	velocity.y += gravity * delta


## Sets player_is_visible to true or false
## Also sets player if setting player_is_visible to true
func _check_if_player_visible() -> void:
	for body in vision.get_overlapping_bodies():
		if body is Player:
			player_is_visible = true
			return
	
	player_is_visible = false


func set_player_is_visible(new_value: bool) -> void:
	player_is_visible = new_value
