extends Node

const LEVELS_FOLDER_PATH: String = "res://levels/level_scenes"

const MAIN_MENU_FILE: String = "res://menus/main_menu/main_menu.tscn"
const LEVEL_SELECT_FILE: String = "res://menus/level select/level_select.tscn"
const SETTINGS_FILE: String = "res://menus/settings/settings.tscn"

var level_strings : Array[String] = [
	"res://levels/level_scenes/level01.tscn",
	"res://levels/level_scenes/level02.tscn",
	"res://levels/level_scenes/level03.tscn",
	"res://levels/level_scenes/level04.tscn",
	"res://levels/level_scenes/level05.tscn",
	"res://levels/level_scenes/level06.tscn",
	"res://levels/level_scenes/level07.tscn",
	"res://levels/level_scenes/level08.tscn",
	"res://levels/level_scenes/level09.tscn",
	"res://levels/level_scenes/level10.tscn",
	"res://levels/level_scenes/level11.tscn",
	"res://levels/level_scenes/level12.tscn",
	"res://levels/level_scenes/level13.tscn",
	"res://levels/level_scenes/level14.tscn",
	#"res://levels/level_scenes/level15.tscn",
]

var current_level: int
var last_unlocked_level: int = 1:
	set = _set_last_unlocked_level


func _ready() -> void:
	SaverLoader.load_game()


func load_main_menu() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	current_level = -1
	get_tree().change_scene_to_file(MAIN_MENU_FILE)


func load_level_select() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	current_level = -1
	get_tree().change_scene_to_file(LEVEL_SELECT_FILE)


func load_settings() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	current_level = -1
	get_tree().change_scene_to_file(SETTINGS_FILE)


func load_level(level_num : int) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	current_level = level_num
	var level_to_load : String = level_strings[level_num - 1]
	get_tree().change_scene_to_file(level_to_load)


func unlock_level() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	if current_level == last_unlocked_level:
		last_unlocked_level = current_level + 1


func load_next_level() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	if current_level == null:
		load_main_menu()
		return
	
	if current_level == level_strings.size():
		load_main_menu()
		return
	
	get_tree().change_scene_to_file(level_strings[current_level])
	current_level += 1


func load_last_unlocked_level() -> void:
	if last_unlocked_level < level_strings.size():
		load_level(last_unlocked_level)
	else:
		load_level(level_strings.size())


func reset() -> void:
	get_tree().reload_current_scene()


func _set_last_unlocked_level(new_value: int) -> void:
	last_unlocked_level = new_value
	SaverLoader.save_game()
