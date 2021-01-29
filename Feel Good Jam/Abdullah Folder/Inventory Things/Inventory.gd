extends Resource
class_name Inventory

signal items_changed (indexes)











enum FISH_TYPES {
	Worm,
	FlyingFish,
	ForgetfulFish,
	ArrowFish,
	TornadoShark,
	JellyFishXP,
	Nyan_CatFish,
	Anglerbird,
	PufferCloud,
	Balloondapus,
	Kite_A_Pus,
	Birdapus,
	Dronedapus,
	UnidentifiedFlyingOctopus
}

enum RARITY {
	Worm,
	Common,
	Rare,
	Legend
}

var item_resources = {
	FISH_TYPES.Worm : "res://Abdullah Folder/Items/Worms.tres" ,
	FISH_TYPES.FlyingFish: "res://Abdullah Folder/Items/FlyingFish.tres",
	FISH_TYPES.ForgetfulFish:"res://Abdullah Folder/Items/ForgetfulFish.tres",
	FISH_TYPES.TornadoShark:"res://Abdullah Folder/Items/Shark.tres",
	FISH_TYPES.JellyFishXP: "res://Abdullah Folder/Items/Jellyfish_XP.tres",
	FISH_TYPES.Nyan_CatFish:"res://Abdullah Folder/Items/Worms.tres", #fix later
	FISH_TYPES.Anglerbird:"res://Abdullah Folder/Items/Anglerbird.tres",
	FISH_TYPES.PufferCloud:"res://Abdullah Folder/Items/Puffercloud.tres",
	FISH_TYPES.Balloondapus:"res://Abdullah Folder/Items/Balloonapus.tres",
	FISH_TYPES.Kite_A_Pus:"res://Abdullah Folder/Items/Worms.tres", #fix later
	FISH_TYPES.Birdapus:"res://Abdullah Folder/Items/Birdapus.tres",
	FISH_TYPES.Dronedapus:"res://Abdullah Folder/Items/Dronedapus.tres",
	FISH_TYPES.UnidentifiedFlyingOctopus:"res://Abdullah Folder/Items/UFOctupus.tres"
}

















#var items_list = preload("res://Abdullah Folder/Items/Items.gd")

export (Array, Resource) var items = [
	null,
	null, null, null, null, null,
	null, null, null, null, null,
	null, null, null, null, null,
	null, null, null, null, null,
	null, null, null, null, null
]

func set_item(item_index, item):
	var previousItem = items[item_index]
	items[item_index] = item
	emit_signal("items_changed", [item_index])
	return previousItem

func swap_items(item_index, target_item_index):
	var targetItem = items[target_item_index]
	var item = items[item_index]
	items[target_item_index] = item
	items[item_index] = targetItem
	emit_signal("items_changed", [item_index, target_item_index])

func remove_item(item_index):
	var previousItem = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previousItem

func make_items_unique():
	var unique_items = []
	for item in items:
		if item is Item:
			unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
	items = unique_items

func find_type(fish_type): #finds if right name is in the array
	for inventory_index in range(self.items.size()):
		if self.items[inventory_index] != null:
			if self.items[inventory_index].type == fish_type:
				return inventory_index
	return -1

func find_first_open(): #finds first open index
	for inventory_index in range(self.items.size()):
		if self.items[inventory_index] == null:
			return inventory_index
	return -1

func push_item(fish_type):
	var found = find_type(fish_type)
	if found >= 0 :
		stack_item(found,1)
	else:
		var free_space = find_first_open()
		if free_space >= 0:
			#var new_item = Items.items[fish_type]
			print(fish_type)
			var new_item = load(item_resources[fish_type])
			set_item(free_space, new_item)
		else:
			print("bruuuuuuuh, not enough space")
			
func stack_item(index, num):
	if items[index].amount + num > 99:
		items[index].amount = 99
	else:
		items[index].amount += num
	emit_signal("items_changed", [index])
	if items[index].amount <= 0:
		remove_item(index)
	
