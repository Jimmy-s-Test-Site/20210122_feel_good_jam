extends ColorRect

export (Resource) var inventory

signal bait_confirmed
var itemM
var item_indexM


func _on_No_pressed():
	self.visible = false


func _on_Yes_pressed():
	inventory.stack_item(item_indexM , (-1))
	self.visible = false

func _on_BaitPrompt_bait_used(item, item_index):
	self.itemM = item
	self.item_indexM = item_index
	self.visible = true
