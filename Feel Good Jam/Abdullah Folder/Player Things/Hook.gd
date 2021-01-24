extends Area2D

signal caught_fish

var bait

func _on_Hook_area_entered(area):
	if area.name == "Mouth":
		emit_signal("caught_fish", area.fish)
