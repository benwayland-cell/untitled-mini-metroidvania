extends Control


func _on_level_select_button_pressed() -> void:
	LevelLoader.load_level_select()


func _ready() -> void:
	SaverLoader._save()
	SaverLoader._load()
