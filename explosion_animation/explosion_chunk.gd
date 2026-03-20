class_name ExplosionChunk
extends RigidBody2D

@export var speed: float = 300.0
@export var spread: float = PI * 0.9

@export var time_until_fade: float = 0.5
@export var fade_speed: float = 1.0

@onready var color_rect: ColorRect = %ColorRect
@onready var timer: Timer = Timer.new()

var color: Color

var fading: bool = false


func _ready() -> void:
	color_rect.color = color
	
	# init fading timer
	timer.wait_time = time_until_fade
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
	
	# set inital velocity
	var angle = randf_range(-spread / 2, spread / 2) - PI / 2
	var direction = Vector2(cos(angle), sin(angle))
	var velocity = direction * randf_range(speed * 0.5, speed)
	apply_central_impulse(velocity)
	angular_velocity = randf_range(-8.0, 8.0)


func _process(delta: float) -> void:
	if fading:
		modulate.a -= fade_speed * delta
		
		if modulate.a <= 0:
			queue_free()


func _on_timer_timeout() -> void:
	fading = true
