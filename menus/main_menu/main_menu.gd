extends Control


func _on_continue_button_pressed() -> void:
	LevelLoader.load_last_unlocked_level()


func _on_level_select_button_pressed() -> void:
	LevelLoader.load_level_select()


func _on_settings_button_pressed() -> void:
	LevelLoader.load_settings()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
