class_name Explosion
extends Node2D

@export var color: Color
@export var dimensions := Vector2i(3, 3)
@export var spacing: float = 4.0
@export var offset := Vector2(0, 8.0)

@export_category("Fading")
@export var time_until_fade: float = 0.5
@export var fade_speed: float = 1.0

@onready var timer: Timer = Timer.new()

const EXPLOSION_CHUNK_SCENE: PackedScene = preload("uid://da4khkeph1ri3")

var fading: bool = false


func _ready() -> void:
	# init fading timer
	timer.wait_time = time_until_fade
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
	
	# get the pos of the bottom-left chunk
	var starting_pos := Vector2.ZERO
	starting_pos.x = (dimensions.x - 1) / 2.0 * spacing
	starting_pos.y = (dimensions.y - 1) / 2.0 * spacing
	starting_pos += offset
	
	# make the explosion chunks
	for row_index in range(dimensions.y):
		for col_index in range(dimensions.x):
			var new_chunk: ExplosionChunk = EXPLOSION_CHUNK_SCENE.instantiate()
			new_chunk.color = color
			new_chunk.position = starting_pos + Vector2(col_index * spacing, row_index * spacing)
			add_child(new_chunk)



func _process(delta: float) -> void:
	if fading:
		modulate.a -= fade_speed * delta
		
		if modulate.a <= 0:
			queue_free()


func _on_timer_timeout() -> void:
	fading = true
