extends Node2D

signal harvest

export (float) var reel_speed = 0.01
export (Array) var limits = [0.2, 2]

var item = null

var has_fish = false

onready var string_sprite_height = $String/Sprite.texture.get_height()
onready var initial_string_height = string_sprite_height * $String/Sprite.scale * $String.scale
onready var string_height = initial_string_height


func _ready():
	$HookContainer.position = Vector2.DOWN * initial_string_height
	limits[0] *= initial_string_height
	limits[1] *= initial_string_height


func reel(direction): #direction should only be 0,1, or -1
	if direction == 0:
		return
		
	var within_limits = self.position > limits[0] and self.position < limits[1]
	
	if within_limits:
		$String.scale.y += reel_speed * direction
		string_height = string_sprite_height * $String/Sprite.scale * $String.scale
		$HookContainer.position = Vector2.DOWN * string_height
		
	if direction == -1 and self.position <= limits[0]:
		emit_signal("harvest", item.type)
		has_fish = false


func _on_Hook_caught_fish(item):
	self.item = item
	has_fish = true
