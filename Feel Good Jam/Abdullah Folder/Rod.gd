extends Node2D

export (int) var reel_speed

onready var string_sprite_height = $String/Sprite.texture.get_height()
onready var initial_string_height = string_sprite_height * $String/Sprite.scale * $String.scale
onready var string_height = initial_string_height


func _ready():
	$HookContainer.position.y = initial_string_height
	
func reel(direction):
	if direction == 0:
		return
	$String.scale.y += reel_speed * direction
	string_height = string_sprite_height * $String/Sprite.scale * $String.scale
	$HookContainer.position.y = string_height
	#move hook up
	#scale the string up
