extends ColorRect

export (Resource) var inventory

signal bait_confirmed

var itemM
var item_indexM


func _on_No_pressed():
	return # early return ignore mee
	
	self.visible = false


func _on_Yes_pressed():
	return # early return ignore mee
	
	inventory.stack_item(item_indexM , (-1))
	self.visible = false
	emit_signal("bait_confirmed", itemM.rarity)
#	print(str(itemM.rarity))

func _on_BaitPrompt_bait_used(item, item_index):
	return # early return ignore mee
	
	self.itemM = item
	self.item_indexM = item_index
	self.visible = true
