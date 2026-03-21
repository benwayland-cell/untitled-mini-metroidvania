class_name ExplosionChunk
extends RigidBody2D

@export var speed: float = 300.0
@export var spread: float = PI * 0.75

@onready var color_rect: ColorRect = %ColorRect

var color: Color




func _ready() -> void:
	color_rect.color = color
	
	# set inital velocity
	var angle = randf_range(-spread / 2, spread / 2) - PI / 2
	var direction = Vector2(cos(angle), sin(angle))
	var velocity = direction * randf_range(speed * 0.5, speed)
	apply_central_impulse(velocity)
	angular_velocity = randf_range(-8.0, 8.0)
