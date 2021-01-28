extends Fish

var direction

export (Resource) var item

export (float, 0, 1) var y_min
export (float, 0, 1) var y_max

func _ready():
	randomize()
	self.select_spawn_position()
	self.rotation = self.direction
	$AnimationPlayer.play("move")

func select_spawn_position():
	var side_length = (self.y_max - self.y_min) * self.viewport_size.y
	var perimeter = int(2 * side_length)
	var random_perimeter_point = randi() % perimeter
	
	var x = 0
	var y = random_perimeter_point
	
	var facing_right = random_perimeter_point < side_length
	
	if facing_right:
		x = 0
		y = (random_perimeter_point) + (self.y_min * self.viewport_size.y)
		
		self.direction = 0
		self.scale.y = abs(scale.y)
	else:
		x = self.viewport_size.x
		y = (random_perimeter_point - side_length) + (self.y_min * self.viewport_size.y)
		
		self.direction = PI
		self.scale.y = -abs(scale.y)
	
	self.global_position = Vector2(x, y)
	
	self.direction *= -1

func _physics_process(delta):
	movement_manager(delta)

func movement_manager(delta):
	var movement = (Vector2.RIGHT * self.speed).rotated(direction)
	
	self.position += movement * delta

func fish():
	self.queue_free()
