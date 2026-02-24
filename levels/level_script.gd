class_name Level
extends Node2D

signal any_button_pressed

@export var player: Player
@export var level_overlay: LevelOverlay

@export var end_level_time_scale: float = 0.5
@export var end_level_slomo_time: float = 1.0


var won_game: bool = false
var player_dead: bool = false


func _ready() -> void:
	assert(player != null, "You forgot to add the player in %s" % name)
	assert(level_overlay != null, "You forgot to add the level_overlay in %s" % name)
	
	player.player_killed.connect(_on_player_player_killed)


func _process(_delta: float) -> void:
	if get_tree().get_nodes_in_group("enemies").size() == 0 and not won_game:
		await win_game()
		return


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
	
	player.disabled = true
	
	await level_overlay.wait_for_loss_screen()
	
	LevelLoader.reset()
