extends Node

const MAIN_MENU_FILE : String = "res://menus/main_menu/main_menu.tscn"
const LEVEL_SELECT_FILE : String = "res://menus/level select/level_select.tscn"

const LEVEL_STRINGS : Array[String] = [
	"uid://byjpq3m0t0jvh", # is currently test_level
	"uid://gvoi4bc2j8aw", # level 1
]

var current_level: int
var last_unlocked_level: int = 1


func load_main_menu() -> void:
	current_level = -1
	get_tree().change_scene_to_file(MAIN_MENU_FILE)


func load_level_select() -> void:
	current_level = -1
	get_tree().change_scene_to_file(LEVEL_SELECT_FILE)


func load_level(level_num : int) -> void:
	current_level = level_num
	var level_to_load : String = LEVEL_STRINGS[level_num - 1]
	get_tree().change_scene_to_file(level_to_load)


func unlock_level() -> void:
	if current_level == last_unlocked_level:
		last_unlocked_level = current_level + 1


func load_next_level() -> void:
	get_tree().change_scene_to_file(LEVEL_STRINGS[current_level])
	current_level += 1
