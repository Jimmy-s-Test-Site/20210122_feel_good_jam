extends Area2D
class_name Fish

onready var viewport_size = self.get_viewport().size

export (int) var speed = 100

func _process(delta):
	if (
		self.global_position.x < - 100 or
		self.global_position.x >  1300 or
		self.global_position.y < - 100 or
		self.global_position.y >   900
	):
		self.queue_free()
