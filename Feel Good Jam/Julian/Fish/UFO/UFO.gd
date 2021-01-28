extends Fish

var direction
var total_time = 0

export (Resource) var item

export (float) var amplitude = PI/4 # between 0 - PI/2
export (float) var steer_speed = 1

func _ready():
	randomize()
	self.select_spawn_position()
	$AnimationPlayer.play("move")

func select_spawn_position():
	var perimeter = int(self.viewport_size.x)
	var random_perimeter_point = randi() % perimeter
	
	var x = random_perimeter_point
	var y = self.viewport_size.y
	
	# 50% chance
	var facing_right = randi() % 2 == 0
	
	if facing_right:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
	
	self.global_position = Vector2(x, y)

func _physics_process(delta):
	movement_manager(delta)

func movement_manager(delta):
	self.total_time += delta
	
	var a = self.amplitude
	var f = self.steer_speed
	var x = self.total_time
	self.direction = a * cos(f * x) * f
	
	var movement = (Vector2.UP * self.speed).rotated(-direction)
	
	self.position += movement * delta

func fish():
	self.queue_free()
