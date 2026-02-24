extends Node2D

@export var end_level_time_scale: float = 0.5
@export var end_level_slomo_time: float = 1.0

@onready var win_screen: CanvasLayer = %WinScreen


func _process(_delta: float) -> void:
	if get_tree().get_nodes_in_group("enemies").size() == 0:
		win_game()


func _on_player_player_killed() -> void:
	print("Player Died")


func win_game() -> void:
	Engine.time_scale = end_level_time_scale
	
	await get_tree().create_timer(end_level_slomo_time * end_level_time_scale).timeout
	
	get_tree().paused = true
	win_screen.show()
