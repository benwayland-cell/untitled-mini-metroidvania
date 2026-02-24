class_name Level
extends Node2D

@export var player: Player

@export var end_level_time_scale: float = 0.5
@export var end_level_slomo_time: float = 1.0

@onready var win_screen: CanvasLayer = %WinScreen
# used by win_screen after it shows up
var all_released: bool = false
var button_pressed_after_released: bool = false


func _process(_delta: float) -> void:
	if get_tree().get_nodes_in_group("enemies").size() == 0 and not win_screen.visible:
		win_game()
	
	if not win_screen.visible:
		return
	
	var is_anything_pressed: bool = Input.is_anything_pressed()
	
	#print(all_released)
	#print(button_pressed_after_released)
	#print()
	
	if not all_released and not is_anything_pressed:
		all_released = true
		return
	
	if not button_pressed_after_released and all_released and is_anything_pressed:
		button_pressed_after_released = true
		return
	
	if button_pressed_after_released and not is_anything_pressed:
		win_screen_button_pressed()


func _on_player_player_killed() -> void:
	print("Player Died")


func win_game() -> void:
	LevelLoader.unlock_level()
	Engine.time_scale = end_level_time_scale
	
	await get_tree().create_timer(end_level_slomo_time * end_level_time_scale).timeout
	
	player.disabled = true
	win_screen.show()


func win_screen_button_pressed() -> void:
	Engine.time_scale = 1
	LevelLoader.load_next_level()
