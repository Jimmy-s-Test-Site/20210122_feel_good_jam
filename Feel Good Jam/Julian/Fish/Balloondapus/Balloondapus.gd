extends Fish

onready var direction = 0

export (Resource) var item

export (float) var angle = PI/12

func _ready():
	randomize()
	self.select_spawn_position()
	#self.rotation = self.direction
	$AnimationPlayer.play("move")

func select_spawn_position():
	var perimeter = int(self.viewport_size.x)
	var random_perimeter_point = randi() % perimeter
	
	var x = random_perimeter_point
	var y = self.viewport_size.y
	
	# this happens 50%
	var facing_right = randi() % 2 == 0
	
	if facing_right:
		scale.x = abs(scale.x)
	else:
		scale.x = -abs(scale.x)
	
	self.direction = $CollisionShape2D.global_rotation
	
	self.global_position = Vector2(x, y)

func _physics_process(delta):
	movement_manager(delta)

func movement_manager(delta):
	var movement = Vector2(
		cos(self.direction),
		sin(self.direction)
	) * self.speed
	
	self.position += movement * delta

func fish():
	self.queue_free()
