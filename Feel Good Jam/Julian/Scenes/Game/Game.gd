extends Node2D

export (NodePath) var fish_container_path
export (Array, Resource) var biomes
export (Resource) var init_biome
export (float) var fish_spawn_time

onready var fish_container = self.get_node_or_null(fish_container_path)
onready var curr_biome = self.init_biome

func _ready():
	$FishSpawnTimer.start(self.fish_spawn_time)

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
