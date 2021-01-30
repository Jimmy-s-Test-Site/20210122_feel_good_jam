extends Area2D

enum RARITY {
	Worm,
	Common,
	Rare,
	Legend
}

export (Texture) var fish_texture
export (Texture) var no_fish_texture

signal caught_fish

var rarity_type

var has_fish = false

func _on_Hook_area_entered(area):
	if area.name.find("Fish", 0) != -1:
		self.has_fish = true
		$Sprite.texture = self.fish_texture
		emit_signal("caught_fish", area.item)
		area.queue_free()

func remove_fish():
	self.has_fish = false
	$Sprite.texture = self.no_fish_texture

func set_bait_rarity(rarity):
	self.rarity_type = rarity
