extends ColorRect

signal bait_used

func _on_No_pressed():
	self.visible = false


func _on_Yes_pressed():
	emit_signal("bait_used")
	self.visible = false
