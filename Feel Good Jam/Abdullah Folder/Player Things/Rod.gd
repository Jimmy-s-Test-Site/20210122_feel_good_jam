extends Node2D

signal harvest

export (float) var reel_speed = 0.03
export (Array) var limits = [0.1, 5]

var item = null

var has_fish = false

onready var string_sprite_height = $String/Sprite.texture.get_height()
onready var initial_string_height = string_sprite_height * $String/Sprite.scale.y * $String.scale.y
onready var string_height = initial_string_height


func _ready():
	$HookContainer.position = Vector2.DOWN * initial_string_height
	#limits[0] *= initial_string_height
	#limits[1] *= initial_string_height


func reel(direction): #direction should only be 0,1, or -1
	if direction == 0:
		return
	
#	print ($String.scale.y)
#	 (limits)
	var within_limits = $String.scale.y >= limits[0] and $String.scale.y <= limits[1]
	
	
	if within_limits:
		#print(within_limits)
		$String.scale.y += reel_speed * direction
		$String.scale.y = clamp($String.scale.y, limits[0], limits[1])
		string_height = string_sprite_height * $String/Sprite.scale * $String.scale
		$HookContainer.position = Vector2.DOWN * string_height
		
	if (
		direction == -1 and 
		$String.scale.y <= limits[0] + .01 and
		has_fish
	):
		if item is Item:
			emit_signal("harvest", item.type)
			has_fish = false


func _on_Hook_caught_fish(item):
	self.item = item
	has_fish = true
