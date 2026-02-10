class_name LevelButton
extends Button

const CUSTOM_MIN_SIZE := Vector2(50, 50)

var level_num : int

func _init(given_level_num : int) -> void:
	level_num = given_level_num


func _ready() -> void:
	text = str(level_num)
	custom_minimum_size = CUSTOM_MIN_SIZE
	connect("pressed", _on_pressed)


func _on_pressed() -> void:
	LevelLoader.load_level(level_num)
