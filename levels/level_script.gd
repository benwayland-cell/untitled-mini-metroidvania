class_name Level
extends Node2D

signal any_button_pressed

@export var player: Player
@export var level_overlay: LevelOverlay

@export var end_level_time_scale: float = 0.5
@export var end_level_slomo_time: float = 1.0

@export var camera_shake_strength: float = 30.0
@export var camera_shake_fade: float = 5.0

var current_camera_shake_strenth: float = 0.0

const DEATH_AUDIO_PATH := "uid://b5j5gsj4iwx7b"
var death_audio: AudioStreamPlayer

const SLOMO_AUDIO_PATH := "uid://dcboy67l6vpfh"
var slomo_audio: AudioStreamPlayer


var won_game: bool = false
var player_dead: bool = false

var enemy_count: int

var camera: Camera2D


func _ready() -> void:
	assert(player != null, "You forgot to add the player in %s" % name)
	assert(level_overlay != null, "You forgot to add the level_overlay in %s" % name)
	
	death_audio = AudioStreamPlayer.new()
	death_audio.stream = preload(DEATH_AUDIO_PATH)
	add_child(death_audio)
	
	slomo_audio = AudioStreamPlayer.new()
	slomo_audio.stream = preload(SLOMO_AUDIO_PATH)
	add_child(slomo_audio)
	
	player.player_killed.connect(_on_player_player_killed)
	player.has_sword_activated.connect(_on_player_has_sword_activated)
	player.has_double_jump_ability_activated.connect(has_double_jump_ability_activated)
	player.has_dash_activated.connect(_on_has_dash_activated)
	
	
	enemy_count = 0
	for child in get_children():
		if child is Enemy:
			_add_enemy(child)
		elif child is Camera2D:
			camera = child
		else:
			if child.get_class() == "Node":
				for child2 in child.get_children():
					if child2 is Enemy and child2.visible:
						_add_enemy(child2)


func _add_enemy(enemy: Enemy) -> void:
	enemy.died.connect(_on_enemy_killed)
	enemy_count += 1


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		level_overlay.pause()
	
	if Input.is_action_just_pressed("debug 1"):
		shake_camera()
	
	# handle returning camera
	if current_camera_shake_strenth > 0:
		current_camera_shake_strenth = lerpf(current_camera_shake_strenth, 0, camera_shake_fade * delta)
		
		camera.offset = Vector2(
			randf_range(-camera_shake_strength, camera_shake_strength),
			randf_range(-camera_shake_strength, camera_shake_strength)
		)


func shake_camera() -> void:
	current_camera_shake_strenth = camera_shake_strength


func win_game() -> void:
	won_game = true
	LevelLoader.unlock_level()
	
	# slomo
	slomo_audio.play()
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
	death_audio.play()
	
	await level_overlay.wait_for_loss_screen()
	
	LevelLoader.reset()


func _on_enemy_killed() -> void:
	death_audio.play()
	enemy_count -= 1
	
	if enemy_count == 0 and not player_dead:
		await win_game()


func _on_player_has_sword_activated() -> void:
	level_overlay.add_upgrade(LevelOverlay.Upgrades.SWORD)


func has_double_jump_ability_activated() -> void:
	level_overlay.add_upgrade(LevelOverlay.Upgrades.DOUBLE_JUMP)


func _on_has_dash_activated() -> void:
	level_overlay.add_upgrade(LevelOverlay.Upgrades.DASH)
