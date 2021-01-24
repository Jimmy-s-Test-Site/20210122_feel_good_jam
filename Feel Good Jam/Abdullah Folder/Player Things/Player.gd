extends KinematicBody2D






enum FISH_TYPES {
	Worm,
	FlyingFish,
	ArrowFish,
	TornadoShark,
	JellyFishXP,
	Nyan_CatFish,
	PufferCloud,
	Balloondapus,
	Kite_A_Pus,
	Birdapus,
	Dronedapus,
	UnidentifiedFlyingOctopus,
}

enum RARITY {
	Worm,
	Common,
	Rare,
	Legend
}

var item_resources = {
	FISH_TYPES.Worm : "res://Abdullah Folder/Items/Worms.tres"
}












export (Resource) var inventory

export (Dictionary) var animations = {
}

const items_list = preload("res://Abdullah Folder/Items/Items.gd")

onready var animation_player = $AnimationPlayer

var velocity := Vector2.ZERO

var input = {
	"cast_hook" : false,
	"inventory_toggle" : false,
	"sit_toggle" : false,
	"facing_direction" : 0,
	"hook_direction" : 0
}

# helper functions

func play_at_speed(animation : String, speed : float) -> void:
	self.animation_player.playback_speed = speed
	self.animation_player.play(animation)

# engine defined functions

func _ready() -> void:
#	while true:
#		yield(get_tree().create_timer(1), "timeout") 
#		inventory.push_item(items_list.FISH_TYPES.Worm)
	#$AnimationPlayer.playback_speed = 2
	#$AnimationPlayer.play("Walking")
	pass

var isTrue = 99
func _physics_process(delta : float) -> void:
	self.input_manager()
	self.movement_manager(delta)
	self.animation_manager()
	while isTrue > 0:
		add_item()
		print("hey")
		isTrue -= 1

func add_item():
	#yield(get_tree().create_timer(1), "timeout") 
	inventory.push_item(FISH_TYPES.Worm)



# user defined functions

func input_manager() -> void:
	self.input.cast_hook   = Input.is_action_just_pressed("cast_hook")
	self.input.inventory_toggle = Input.is_action_just_pressed("inventory_toggle")
	self.input.sit_toggle = Input.is_action_just_pressed("sit_toggle")
	self.input.facing_direction = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	self.input.hook_direction = int(Input.is_action_pressed("hook_up")) - int(Input.is_action_pressed("hook_down"))


func movement_manager(delta : float) -> void:
	self.velocity.x = self.input.facing_direction * 5000
	self.velocity.y = 0
	#FI
	self.velocity = self.move_and_slide(self.velocity)


func animation_manager() -> void:
	pass


func _on_Rod_harvest(fish_type):
	inventory.push_item(fish_type)
