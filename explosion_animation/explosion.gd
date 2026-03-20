class_name Explosion
extends Node2D

var color: Color: set = _set_color

func _set_color(new_color: Color) -> void:
	if color == new_color:
		return
	color = new_color
	
	for child: ExplosionChunk in get_children():
		child.color = color
