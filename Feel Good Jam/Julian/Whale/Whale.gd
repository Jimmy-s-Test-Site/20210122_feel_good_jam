extends KinematicBody2D

var total_time = 0
export (float) var frequency = 5

export (float, 0, 1) var init_altitude
export (float) var amplitude

func _physics_process(delta):
	self.total_time += delta
	
	self.position = Vector2(0, self.init_altitude * get_viewport().get_size().y)
	
	var velocity = Vector2(0, (self.amplitude * get_viewport().get_size().y) * cos(self.frequency * self.total_time))
	
	print(velocity.y)
	
	self.move_and_slide(velocity)
