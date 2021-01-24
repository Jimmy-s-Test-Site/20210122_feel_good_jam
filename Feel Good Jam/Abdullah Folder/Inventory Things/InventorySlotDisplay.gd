extends CenterContainer

signal bait_used

var has_item = false
#var inventory = preload("res://Abdullah Folder/Inventory Things/Inventory.tres")

export (Resource) var inventory
export (Texture) var item_texture_miiiiine


onready var itemTextureRect = $ItemTextureRect 
onready var itemAmountLabel = $ItemTextureRect/ItemAmountLabel


func display_item(item):
	if item is Item:
		has_item = true
		itemTextureRect.texture = item.texture
		itemAmountLabel.text = str(item.amount)
	else:
		has_item = false
		#itemTextureRect.texture = load("res://Abdullah Folder/Inventory Things/Untitled.png")
		itemTextureRect.texture = item_texture_miiiiine
		itemAmountLabel.text = ""

func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		set_drag_preview(dragPreview)
		#inventory.drag_data = data
		return data
		

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	if my_item is Item and my_item.type == data.item.type:
		inventory.stack_item(my_item_index,data.item.amount)
		#my_item.amount += data.item.amount
		#inventory.emit_signal("items_changed", [my_item_index])
	else:
		inventory.swap_items(my_item_index, data.item_index)
		inventory.set_item(my_item_index, data.item)
#	inventory.drag_data = null

func _input(event):
	if has_item:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_RIGHT and event.pressed:
				var my_item_index = get_index()
				var my_item =  inventory.items[my_item_index]
				var global_position = self.get_global_transform().get_origin()
				var global_scale = self.get_global_transform().get_scale()
				
				var edges = {
					"left" : global_position.x,
					"right" :global_position.x + (self.rect_size.x * global_scale.x),
					"top" : global_position.y,
					"bottom" : global_position.y + (self.rect_size.y * global_scale.y)
				}
				if (
					event.global_position.x > edges.left 
					and event.global_position.x < edges.right
					and event.global_position.y > edges.top
					and event.global_position.y < edges.bottom
				):
					emit_signal("bait_used", my_item, my_item_index)

#func _on_InventorySlotDisplay_focus_entered():
#	print("sup homie")	
