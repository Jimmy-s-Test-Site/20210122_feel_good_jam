extends KinematicBody2D

var total_time = 0

export (float) var DEBUG_speed

export (Dictionary) var outer_wave = {
	"init_altitude" : 0.5,
	"amplitude" : 0.5,
	"frequency" : 1.0
}

export (Dictionary) var inner_wave = {
	"amplitude" : 0.5,
	"frequency" : 1.0
}

func _ready():
	self.position = Vector2(
		self.get_viewport().get_size().x/2,
		self.outer_wave.init_altitude * self.get_viewport().get_size().y
	)

func _physics_process(delta):
	self.total_time += delta
	
	var a
	var f
	var x = self.total_time
	
	a = (self.outer_wave.amplitude * get_viewport().get_size().y)
	f = self.outer_wave.frequency
	var outer = a * cos(f * x) * f
	
	a = (self.inner_wave.amplitude * get_viewport().get_size().y)
	f = self.inner_wave.frequency
	var inner = a * cos(f * x) * f
	
	var velocity = Vector2(0, outer + inner)
	
	self.move_and_slide(velocity)
