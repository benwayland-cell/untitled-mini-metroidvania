class_name Spike
extends StaticBody2D

@onready var hurt_box: Area2D = %HurtBox

func _process(_delta: float) -> void:
	for body in hurt_box.get_overlapping_bodies():
		if body is Player:
			body.kill()
		elif body is Enemy:
			body.take_damage(999, self)
