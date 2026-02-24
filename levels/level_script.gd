class_name Level
extends Node2D

signal any_button_pressed

@export var player: Player

@export var end_level_time_scale: float = 0.5
@export var end_level_slomo_time: float = 1.0

@onready var win_screen: CanvasLayer = %WinScreen

var won_game: bool = false

# used for waiting for any button to be pressed
var wait_for_any_button_pressed: bool = false
var all_released: bool = false
var button_pressed_after_released: bool = false


func _process(_delta: float) -> void:
	if get_tree().get_nodes_in_group("enemies").size() == 0 and not won_game:
		await win_game()
		return
	
	if not wait_for_any_button_pressed:
		return
	
	var is_anything_pressed: bool = Input.is_anything_pressed()
	
	if not all_released and not is_anything_pressed:
		all_released = true
		return
	
	if not button_pressed_after_released and all_released and is_anything_pressed:
		button_pressed_after_released = true
		return
	
	if button_pressed_after_released and not is_anything_pressed:
		all_released = false
		button_pressed_after_released = false
		any_button_pressed.emit()


func _on_player_player_killed() -> void:
	print("Player Died")


func win_game() -> void:
	won_game = true
	LevelLoader.unlock_level()
	
	# slomo
	Engine.time_scale = end_level_time_scale
	await get_tree().create_timer(end_level_slomo_time * end_level_time_scale).timeout
	Engine.time_scale = 1
	
	# disable the player and show the win screen
	player.disabled = true
	win_screen.show()
	
	# wait until any button is pressed
	wait_for_any_button_pressed = true
	await any_button_pressed
	
	LevelLoader.load_next_level()
