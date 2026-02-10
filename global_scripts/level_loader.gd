extends Node

const MAIN_MENU_FILE : String = "res://menus/main_menu/main_menu.tscn"
const LEVEL_SELECT_FILE : String = "res://menus/level select/level_select.tscn"

const LEVEL_STRINGS : Array[String] = [
	"res://levels/test_level.tscn",
	"res://levels/level1.tscn",
]

var last_unlocked_level : int

func load_main_menu() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_FILE)

func load_level_select() -> void:
	get_tree().change_scene_to_file(LEVEL_SELECT_FILE)

func load_level(level_num : int) -> void:
	var level_to_load : String = LEVEL_STRINGS[level_num - 1]
	get_tree().change_scene_to_file(level_to_load)
