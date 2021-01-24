extends ColorRect

export (Resource) var inventory
signal bait_confirmed

func _on_No_pressed():
	self.visible = false


func _on_Yes_pressed():
#	inventory.stack_item(rand_range(25) ,-1)
	self.visible = false

func _on_BaitPrompt_bait_used(item):
	print("somethoong")
	self.visible = true

