extends Fish

var total_time = 0

export (Resource) var item

export (float) var bottom_side_spawn
export (float) var inclination = 1

export (float) var amplitude = 0.5
export (float) var frequency = 1.0

var direction = 1

func _ready():
	randomize()
	self.select_spawn_position()
	$AnimationPlayer.play("move")

func select_spawn_position():
	var side_length = self.viewport_size.y + self.bottom_side_spawn
	var perimeter = int(2 * side_length + self.viewport_size.x)
	var random_perimeter_point = randi() % perimeter
	
	var x = 0
	var y = 0
	
	var left_edge = random_perimeter_point < side_length
	var right_edge = random_perimeter_point > side_length + self.viewport_size.x
	var bottom_edge = not left_edge and not right_edge
	
	var facing_right = left_edge or (bottom_edge and (random_perimeter_point - side_length) < self.viewport_size.x/2)
	
	if left_edge:
		x = 0
		y = random_perimeter_point
	elif right_edge:
		x = self.viewport_size.x
		y = random_perimeter_point - self.viewport_size.x - side_length
	else:
		x = random_perimeter_point - side_length
		y = self.viewport_size.y
	
	self.global_position = Vector2(x, y)
	
	if facing_right:
		self.scale.x = abs(scale.x)
		self.direction = 1
	else:
		self.scale.x = -abs(scale.x)
		self.direction = -1

func _physics_process(delta):
	movement_manager(delta)

func movement_manager(delta):
	self.total_time += delta
	
	var a = self.amplitude
	var f = self.frequency
	var x = self.total_time
	
	var movement = a * cos(f * x) * f + self.inclination
	
	self.position += Vector2(self.direction * self.speed, -self.speed * movement) * delta

func fish():
	self.queue_free()
