extends Control


const WRAP_NUMBER := 5


func _ready() -> void:
	var current_h_box := HBoxContainer.new()
	var buttons_in_row : int = 0
	
	# for every level
	for level_num in range(1, LevelLoader.level_strings.size() + 1):
		# if we need to wrap around
		if buttons_in_row >= WRAP_NUMBER:
			%LevelRows.add_child(current_h_box)
			current_h_box = HBoxContainer.new()
			buttons_in_row = 0
		
		var new_button = LevelButton.new(level_num)
		
		current_h_box.add_child(new_button)
		buttons_in_row += 1
		
		if level_num > LevelLoader.last_unlocked_level:
			new_button.disabled = true
	
	%LevelRows.add_child(current_h_box)


func _on_back_button_pressed() -> void:
	LevelLoader.load_main_menu()
