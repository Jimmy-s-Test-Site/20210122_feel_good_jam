extends Resource
class_name Biome

export (String) var name
export (Array, PackedScene) var fishes

func has_fish() -> bool:
	return self.fishes.size() > 0
