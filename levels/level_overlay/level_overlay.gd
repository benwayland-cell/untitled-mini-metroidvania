class_name LevelOverlay
extends CanvasLayer

signal any_button_pressed

const WIN_SCREEN_TEXT: String = "Level Win"
const LOSS_SCREEN_TEXT: String = "You Died"

@onready var win_lose_container: PanelContainer = %WinLoseContainer
@onready var variable_label: Label = %VariableLabel
@onready var upgrade_display: HBoxContainer = %UpgradeDisplay

@onready var pause_menu: MarginContainer = %PauseMenu

enum Upgrades {SWORD, DOUBLE_JUMP, DASH}
const SWORD_UPGRADE_TEXTURE: Texture2D = preload("uid://dccykbn0imq2k")
const DOUBLE_JUMP_UPGRADE_TEXTURE: Texture2D = preload("uid://cxkt6o3i3ugrp")
const DASH_UPGRADE_TEXTURE: Texture2D = preload("uid://l3f3rwvaij1d")

var wait_for_any_button_pressed: bool = false

var all_released: bool = false
var button_pressed_after_released: bool = false


func _process(_delta: float) -> void:
	_handle_wait_for_any_button_pressed()


############## Win / Lose Screen


func _handle_wait_for_any_button_pressed() -> void:
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


func _wait_for_button_press() -> void:
	win_lose_container.show()
	wait_for_any_button_pressed = true
	await any_button_pressed
	wait_for_any_button_pressed = false
	all_released = false
	button_pressed_after_released = false
	win_lose_container.hide()


func wait_for_win_screen() -> void:
	variable_label.text = WIN_SCREEN_TEXT
	await _wait_for_button_press()


func wait_for_loss_screen() -> void:
	variable_label.text = LOSS_SCREEN_TEXT
	await _wait_for_button_press()


############## Pause Menu


func pause() -> void:
	if win_lose_container.visible:
		return
	
	get_tree().paused = true
	pause_menu.show()


func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	pause_menu.hide()


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	LevelLoader.reset()


func _on_level_select_button_pressed() -> void:
	get_tree().paused = false
	LevelLoader.load_level_select()


############## Upgrade Display

func add_upgrade(upgrade: Upgrades) -> void:
	var texture_to_add: Texture2D
	
	match upgrade:
		Upgrades.SWORD:
			texture_to_add = SWORD_UPGRADE_TEXTURE
		
		Upgrades.DOUBLE_JUMP:
			texture_to_add = DOUBLE_JUMP_UPGRADE_TEXTURE
		
		Upgrades.DASH:
			texture_to_add = DASH_UPGRADE_TEXTURE
	
	var new_texture_rect := TextureRect.new()
	new_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP
	new_texture_rect.size_flags_vertical = Control.SIZE_SHRINK_END
	new_texture_rect.texture = texture_to_add
	upgrade_display.add_child(new_texture_rect)
