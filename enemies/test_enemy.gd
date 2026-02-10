extends StaticBody2D
class_name TestEnemy

@export var health :int= 1
@export var drop : PackedScene = null

signal died

func take_damage(damage_amount: int, player : Player) -> void:
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
		
		queue_free()
