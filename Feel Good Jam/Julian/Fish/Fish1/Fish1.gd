extends Fish

var direction

export (Resource) var item

func _ready():
	randomize()
	self.select_spawn_position()
	self.rotation = self.direction
	$AnimationPlayer.play("move")

func select_spawn_position():
	var perimeter = int(2 * self.viewport_size.y)
	var random_perimeter_point = randi() % perimeter
	
	var x = 0
	var y = random_perimeter_point
	
	self.direction = fmod(randf() * PI/12 - PI/24, 2*PI)
	
	var facing_right = random_perimeter_point < self.viewport_size.y
	
	if facing_right:
		x = 0
		y = random_perimeter_point
		
		self.direction = fmod(self.direction, 2*PI)
		
		scale.y = abs(scale.y)
	else:
		x = self.viewport_size.x
		y = random_perimeter_point - self.viewport_size.y
		
		self.direction = fmod(self.direction - PI, 2*PI)
		
		scale.y = -abs(scale.y)
	
	self.global_position = Vector2(x, y)
	
	self.direction *= -1

func _physics_process(delta):
	movement_manager(delta)

func movement_manager(delta):
	var movement = (Vector2.RIGHT * self.speed).rotated(direction)
	
	self.position += movement * delta

func fish():
	self.queue_free()
