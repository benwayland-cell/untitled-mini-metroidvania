@tool
class_name BreakableWall
extends StaticBody2D

## Will be deleted with the wall
@export var texture: Texture2D:
	set = _set_sprite

@onready var sprite: Sprite2D = %Sprite2D

const DISTANCE_TO_ANOTHER_BLOCK: float = 16.0

var default_texture: Texture2D
var deleted: bool = false


func _ready() -> void:
	default_texture = sprite.texture
	
	if texture != null:
		sprite.texture = texture


## deltes itself and all other walls around it
func destroy() -> void:
	deleted = true
	queue_free()
	
	for breakable_wall in get_tree().get_nodes_in_group("breakable_wall"):
		if breakable_wall is BreakableWall:
			_check_if_neighbor(breakable_wall)


func _check_if_neighbor(breakable_wall: BreakableWall) -> void:
	if breakable_wall.deleted:
		return
	
	var other_wall_pos: Vector2 = breakable_wall.position
	# if the wall is adjacent
	if (
		(other_wall_pos.x == position.x + DISTANCE_TO_ANOTHER_BLOCK
		or other_wall_pos.x == position.x - DISTANCE_TO_ANOTHER_BLOCK)
		and (other_wall_pos.y == position.y + DISTANCE_TO_ANOTHER_BLOCK
		or other_wall_pos.y == position.y - DISTANCE_TO_ANOTHER_BLOCK)
	):
		breakable_wall.destroy()


func _set_sprite(new_texture: Texture2D) -> void:
	texture = new_texture
	
	if sprite == null:
		return
	
	if texture == null:
		sprite.texture = default_texture
	else:
		sprite.texture = texture
