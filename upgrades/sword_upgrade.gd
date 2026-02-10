extends Area2D


func _process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is Player:
			body.has_sword = true
			queue_free()
