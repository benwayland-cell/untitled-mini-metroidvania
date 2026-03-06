class_name BreakableWall
extends StaticBody2D

## Will be deleted with the wall
@export var attatched_node: Node

const DISTANCE_TO_ANOTHER_BLOCK: float = 16.0


## deltes itself and all other walls around it
func destroy() -> void:
	queue_free()
	
	for breakable_wall in get_tree().get_nodes_in_group("breakable_wall"):
		if not is_instance_valid(breakable_wall):
			continue
		
		if breakable_wall is BreakableWall:
			_check_if_neighbor(breakable_wall)
	
	if attatched_node != null:
		attatched_node.queue_free()


func _check_if_neighbor(breakable_wall: BreakableWall) -> void:
	var other_wall_pos: Vector2 = breakable_wall.position
	# if the wall is adjacent
	if (
		other_wall_pos.x == position.x + DISTANCE_TO_ANOTHER_BLOCK
		or other_wall_pos.x == position.x - DISTANCE_TO_ANOTHER_BLOCK
		or other_wall_pos.y == position.y + DISTANCE_TO_ANOTHER_BLOCK
		or other_wall_pos.y == position.y - DISTANCE_TO_ANOTHER_BLOCK
	):
		breakable_wall.queue_free()
