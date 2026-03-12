extends Node


func save_game() -> void:
	var save_dict = {
		"last_unlocked_level": LevelLoader.last_unlocked_level
	}
	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_file.store_var(save_dict)


# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var load_dict: Dictionary = save_file.get_var()
	
	LevelLoader.last_unlocked_level = load_dict["last_unlocked_level"]
