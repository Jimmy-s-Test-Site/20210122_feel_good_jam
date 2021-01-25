extends Area2D

enum RARITY {
	Worm,
	Common,
	Rare,
	Legend
}

signal caught_fish

var rarity_type

func _on_Hook_area_entered(area):
	if area.name == "Mouth":
		emit_signal("caught_fish", area.item)

func set_bait_rarity(rarity):
	self.rarity_type = rarity
