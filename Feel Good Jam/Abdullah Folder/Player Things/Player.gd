extends KinematicBody2D

signal inventory_open
signal inventory_close

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

export (int) var player_speed = 100

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

var inventory_is_open = false
# helper functions

func play_at_speed(animation : String, speed : float) -> void:
	self.animation_player.playback_speed = speed
	self.animation_player.play(animation)

# engine defined functions

func _ready() -> void:
	var barr = $InventoryContainer/CenterContainer/InventoryDisplay
	for slot in barr.get_children():
		slot.connect("bait_used", $BaitPrompt,"_on_BaitPrompt_bait_used")
	
	$BaitPrompt.connect("bait_confirmed", $Rod/HookContainer/Hook, "set_bait_rarity")
	#$AnimationPlayer.playback_speed = 2
	#$AnimationPlayer.play("Walking")


func _physics_process(delta : float) -> void:
	self.input_manager()
	self.movement_manager(delta)
	self.animation_manager()

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
	self.velocity.x = self.input.facing_direction * player_speed
	self.velocity.y = 0
	#FI
	self.velocity = self.move_and_slide(self.velocity)
	if self.input.inventory_toggle == true:
		if inventory_is_open:
			inventory_is_open= false
			emit_signal("inventory_close")
		else:
			emit_signal("inventory_open")
			inventory_is_open= true


func animation_manager() -> void:
	pass


func _on_Rod_harvest(fish_type):
	inventory.push_item(fish_type)
