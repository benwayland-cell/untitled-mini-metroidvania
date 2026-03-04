class_name Level
extends Node2D

signal any_button_pressed

@export var player: Player
@export var level_overlay: LevelOverlay

@export var end_level_time_scale: float = 0.5
@export var end_level_slomo_time: float = 1.0


var won_game: bool = false
var player_dead: bool = false

var enemy_count: int

func _ready() -> void:
	assert(player != null, "You forgot to add the player in %s" % name)
	assert(level_overlay != null, "You forgot to add the level_overlay in %s" % name)
	
	player.player_killed.connect(_on_player_player_killed)
	
	enemy_count = 0
	for child in get_children():
		if child is Enemy:
			child.died.connect(_on_enemy_killed)
			enemy_count += 1


func win_game() -> void:
	won_game = true
	LevelLoader.unlock_level()
	
	# slomo
	Engine.time_scale = end_level_time_scale
	await get_tree().create_timer(end_level_slomo_time * end_level_time_scale).timeout
	Engine.time_scale = 1
	
	# disable the player and show the win screen
	player.disabled = true
	
	await level_overlay.wait_for_win_screen()
	
	LevelLoader.load_next_level()


func _on_player_player_killed() -> void:
	if player_dead:
		return
	player_dead = true
	
	await level_overlay.wait_for_loss_screen()
	
	LevelLoader.reset()


func _on_enemy_killed() -> void:
	enemy_count -= 1
	
	if enemy_count == 0:
		await win_game()
