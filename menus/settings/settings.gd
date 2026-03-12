extends Control


@onready var graying_color_rect: ColorRect = %GrayingColorRect
@onready var reset_game_confirmation: MarginContainer = %ResetGameConfirmation


func _on_back_button_pressed() -> void:
	LevelLoader.load_main_menu()


func _on_reset_button_pressed() -> void:
	graying_color_rect.show()
	reset_game_confirmation.show()


func _on_do_reset_button_pressed() -> void:
	LevelLoader.last_unlocked_level = 1
	SaverLoader.save_game()
	_on_not_reset_button_pressed()


func _on_not_reset_button_pressed() -> void:
	graying_color_rect.hide()
	reset_game_confirmation.hide()
