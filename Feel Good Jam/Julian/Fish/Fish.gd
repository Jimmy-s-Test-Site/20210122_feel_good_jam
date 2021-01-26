extends Area2D
class_name Fish

onready var viewport_size = get_viewport().size

export (int) var speed = 100

func _process(delta):
	if self.position.y < -500:
		self.queue_free()
