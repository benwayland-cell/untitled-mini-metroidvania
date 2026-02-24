extends Node2D

func _process(_delta: float) -> void:
	if get_tree().get_nodes_in_group("enemies").size() == 0:
		print("Win Condition Met")


func _on_player_player_killed() -> void:
	print("Player Died")
