extends Control


func _on_level_select_button_pressed() -> void:
	LevelLoader.load_level_select()


func _on_settings_button_pressed() -> void:
	LevelLoader.load_settings()
