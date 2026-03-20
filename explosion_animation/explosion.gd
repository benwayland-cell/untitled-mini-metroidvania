class_name Explosion
extends Node2D

@export var color: Color
@export var dimensions := Vector2i(3, 3)
@export var spacing: float = 4.0
@export var offset := Vector2(0, 8.0)

const EXPLOSION_CHUNK_SCENE: PackedScene = preload("uid://da4khkeph1ri3")


func _ready() -> void:
	# get the pos of the top-left chunk
	var starting_pos := Vector2.ZERO
	starting_pos.x = (dimensions.x - 1) / 2.0 * spacing
	starting_pos.y = (dimensions.y - 1) / 2.0 * spacing
	starting_pos += offset
	
	for row_index in range(dimensions.y):
		for col_index in range(dimensions.x):
			var new_chunk: ExplosionChunk = EXPLOSION_CHUNK_SCENE.instantiate()
			new_chunk.color = color
			new_chunk.position = starting_pos + Vector2(col_index * spacing, row_index * spacing)
			add_child(new_chunk)
