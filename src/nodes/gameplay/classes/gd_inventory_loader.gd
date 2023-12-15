extends Node
class_name InventoryWrapper

@onready @export var inventory:Inventory

signal item_added
signal item_removed
signal selected_changed

func _init():
	name = "InventoryWrapper"

var selected_item:int = 0:
	get: return selected_item
	set(value):
		selected_item = clamp(value, 0, inventory.items.size() - 1)
		emit_signal("selected_changed", selected_item)

var last_pick:Item
func add_item(item:Node) -> bool:
	if inventory.items.size() < inventory.size:
		item.get_parent().remove_child(item)
		inventory.items.append(item)
		emit_signal("item_added", item)
		selected_item = inventory.items.size()
		return true
	return false

func remove_item(id:int):
	emit_signal("item_removed", inventory.items[id])
	inventory.items.remove_at(id)
	selected_item = inventory.items.size()
		#rpc("remote_update_inv", inventory.items[id])

func get_item(id:int):
	return inventory.items[id]

#@rpc(reliable)
#func remote_update_inv(item):
	#var dict = inst_to_dict(item)
	#print(item)
	#inventory.items = inv.duplicate()
	#print(inventory.items)
