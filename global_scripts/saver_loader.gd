extends Node

const SAVE_FILE_STRING = "savegame.save"


func _load() -> void:
	if not FileAccess.file_exists(SAVE_FILE_STRING):
		return
	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	print(save_file.get_line())


func _save() -> void:
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(1))
