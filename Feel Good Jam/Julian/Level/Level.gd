extends Node2D

export (NodePath) var fish_container
export (Array, Resource) var biomes
export (Resource) var init_biome
export (float) var fish_spawn_time


var curr_biome = self.init_biome if self.init_biome != null else null

func _ready():
	$FishSpawnTimer.start(self.fish_spawn_time)

func spawn_fish():
	var random_biome_index = randi() % self.biomes.size()
	if self.curr_biome != null and self.fish_container != null:
		var random_fish_index = randi() % self.curr_biome.fishes.size()
		
		var new_fish = self.curr_biome.fishes[random_fish_index].instance()
		
		self.fish_container.add_child(new_fish)

func _on_FishSpawnTimer_timeout():
	self.spawn_fish()
	
	$FishSpawnTimer.start(self.fish_spawn_time)
