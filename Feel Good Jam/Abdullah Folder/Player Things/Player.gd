extends KinematicBody2D

signal inventory_open
signal inventory_close

enum FISH_TYPES {
	Worm,
	FlyingFish,
	ForgetfulFish,
	ArrowFish,
	TornadoShark,
	JellyFishXP,
	Nyan_CatFish,
	Anglerbird,
	PufferCloud,
	Balloondapus,
	Kite_A_Pus,
	Birdapus,
	Dronedapus,
	UnidentifiedFlyingOctopus
}

enum RARITY {
	Worm,
	Common,
	Rare,
	Legend
}

enum STATES {
	walk,
	idle,
	sit,
	fishing
}

var state
var can_sit


var item_resources = {
	FISH_TYPES.Worm : "res://Abdullah Folder/Items/Worms.tres"
}

export (Resource) var inventory
export (Dictionary) var animations = {}
export (int) var player_speed = 100
export (float) var idle_time = 25
export (float) var zoom_speed
export (float) var zoom_min
export (float) var zoom_max

var ready = false

const items_list = preload("res://Abdullah Folder/Items/Items.gd")

onready var animation_player = $AnimationPlayer

onready var state_machine = $AnimationTree.get("parameters/playback")

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
	$Idle_timer.start(self.idle_time)
	#$Camera2D.zoom = Vector2.ONE * self.zoom_max
	state = STATES.idle
	#$AnimationPlayer.playback_speed = 2
	#$AnimationPlayer.play("Walking")


func _physics_process(delta : float) -> void:
	self.input_manager()
	self.movement_manager(delta)
	self.state_manager()
	self.animation_manager()
	

func add_item():
	#yield(get_tree().create_timer(1), "timeout") 
	inventory.push_item(FISH_TYPES.Worm)



# user defined functions

func _input(event):
	var zoom_in = event.is_action_pressed("zoom_in")
	var zoom_out = event.is_action_pressed("zoom_out")
	var zoom = int(zoom_out) - int(zoom_in)
	
	if zoom != 0:
		$Camera2D.zoom += Vector2.ONE * zoom * self.zoom_speed
		var min_zoom_vector = Vector2.ONE * self.zoom_min
		var max_zoom_vector = Vector2.ONE * self.zoom_max
		
		if $Camera2D.zoom.length() < min_zoom_vector.length():
			$Camera2D.zoom = min_zoom_vector
		elif $Camera2D.zoom.length() > max_zoom_vector.length():
			$Camera2D.zoom = max_zoom_vector
		
		print($Camera2D.zoom)

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
	if self.state != STATES.fishing:
		self.velocity = self.move_and_slide(self.velocity)
	else:
		$Rod.reel(-self.input.hook_direction)
	if self.input.inventory_toggle == true:
		if inventory_is_open:
			inventory_is_open= false
			emit_signal("inventory_close")
		else:
			emit_signal("inventory_open")
			inventory_is_open= true
	
	


func state_manager():
	if self.input.facing_direction != 0:
		$Idle_timer.stop()
		self.can_sit =false
		self.state = STATES.walk
	elif self.input.cast_hook:
		$Idle_timer.stop()
		self.can_sit =false
		if self.state == STATES.fishing:
			self.state = STATES.idle
		else:
			self.state = STATES.fishing
	elif self.can_sit and self.state == STATES.idle:
		self.state = STATES.sit
		can_sit = false
	elif (
		self.state != STATES.fishing and 
		self.state != STATES.sit and
		self.state != STATES.idle
	):
		self.state = STATES.idle
		$Idle_timer.start(idle_time)


func animation_manager() -> void:
	if input.facing_direction != 0:
		
		$AnimationTree.set('parameters/Walking/blend_position', input.facing_direction)
		$AnimationTree.set('parameters/Fishing/blend_position', input.facing_direction)
		$AnimationTree.set('parameters/Idle/blend_position', input.facing_direction)
		$AnimationTree.set('parameters/Sitting/blend_position', input.facing_direction)
		$AnimationTree.set('parameters/Cast In/blend_position', input.facing_direction)
		$AnimationTree.set('parameters/Cast Out/blend_position', input.facing_direction)
	match self.state:
		STATES.idle:
			state_machine.travel("Idle")
		STATES.walk:
			state_machine.travel("Walking")
		STATES.fishing:
			state_machine.travel("Fishing")
		STATES.sit:
			state_machine.travel("Sitting")



func _on_Rod_harvest(fish_type):
	inventory.push_item(fish_type)


func _on_Idle_timer_timeout():
#	print("bruuuuuuuuuuuuh")
	self.can_sit = true


