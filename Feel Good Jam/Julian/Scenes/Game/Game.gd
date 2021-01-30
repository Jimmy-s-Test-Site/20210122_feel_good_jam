extends Node2D

export (NodePath) var fish_container_path
export (Array, Resource) var biomes
export (Resource) var init_biome
export (float) var fish_spawn_time
export (Array, Texture) var backgrounds
export (Array, AudioStreamOGGVorbis) var soundtracks
export (float) var background_change_time

onready var fish_container = self.get_node_or_null(fish_container_path)
onready var curr_biome = self.init_biome

var curr_background_index = 0

func _ready():
	$FishSpawnTimer.start(self.fish_spawn_time)

	$TextureRect.texture = self.backgrounds[curr_background_index]

	$BackgroundChangeTimer.start(self.background_change_time)
	pass

func spawn_fish():
	var curr_biome_exists = self.curr_biome != null
	var fish_container_exists = self.fish_container != null
	
	if curr_biome_exists and fish_container_exists:
		if self.curr_biome.has_fish():
			var random_fish_index = randi() % self.curr_biome.fishes.size()
			
			var new_fish = self.curr_biome.fishes[random_fish_index].instance()
			
			self.fish_container.add_child(new_fish)

func _on_FishSpawnTimer_timeout():
	self.spawn_fish()
	$FishSpawnTimer.start(self.fish_spawn_time)

func _on_BackgroundChangeTimer_timeout():
	print("works?")
	
	self.curr_background_index = (self.curr_background_index + 1) % self.backgrounds.size()
	$TextureRect.texture = self.backgrounds[self.curr_background_index]
	$AudioStreamPlayer.stream = self.soundtracks[self.curr_background_index]
	#$TextureRect.texture = self.backgrounds[self.curr_background_index]
	
	var color = float(self.curr_background_index)/self.backgrounds.size()
	$CanvasLayer/Occluder.color = Color(0, 0, 0, color/2)
	
	$BackgroundChangeTimer.start(self.background_change_time)

func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()

func _on_Start_Screen_start_the_game():
	self.visible = true
	$FishSpawnTimer.start(self.fish_spawn_time)
	
	$TextureRect.texture = self.backgrounds[curr_background_index]
	
	$BackgroundChangeTimer.start(self.background_change_time)
