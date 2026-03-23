extends Node

const LEVELS_FOLDER_PATH: String = "res://levels/level_scenes"

const MAIN_MENU_FILE: String = "res://menus/main_menu/main_menu.tscn"
const LEVEL_SELECT_FILE: String = "res://menus/level select/level_select.tscn"
const SETTINGS_FILE: String = "res://menus/settings/settings.tscn"

var level_strings : Array[String] = []

var current_level: int
var last_unlocked_level: int = 1:
	set = _set_last_unlocked_level


func _ready() -> void:
	SaverLoader.load_game()
	
	var dir = DirAccess.open(LEVELS_FOLDER_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				assert(false, "There was a directory found in the levels folder")
			else:
				level_strings.append(LEVELS_FOLDER_PATH + "/" + file_name)
			file_name = dir.get_next()
	else:
		assert(false, "An error occurred when trying to access the path in level loader.")
	print(level_strings)


func load_main_menu() -> void:
	current_level = -1
	get_tree().change_scene_to_file(MAIN_MENU_FILE)


func load_level_select() -> void:
	current_level = -1
	get_tree().change_scene_to_file(LEVEL_SELECT_FILE)


func load_settings() -> void:
	current_level = -1
	get_tree().change_scene_to_file(SETTINGS_FILE)


func load_level(level_num : int) -> void:
	current_level = level_num
	var level_to_load : String = level_strings[level_num - 1]
	get_tree().change_scene_to_file(level_to_load)


func unlock_level() -> void:
	if current_level == last_unlocked_level:
		last_unlocked_level = current_level + 1


func load_next_level() -> void:
	if current_level == null:
		load_main_menu()
		return
	
	if current_level == level_strings.size():
		load_main_menu()
		return
	
	get_tree().change_scene_to_file(level_strings[current_level])
	current_level += 1


func reset() -> void:
	get_tree().reload_current_scene()


func _set_last_unlocked_level(new_value: int) -> void:
	last_unlocked_level = new_value
	SaverLoader.save_game()
