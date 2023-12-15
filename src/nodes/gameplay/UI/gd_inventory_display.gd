extends HBoxContainer

var slot = preload("res://scenes/nodes/UI/sc_slot.tscn")
@onready var inventory_wrapper:InventoryWrapper = owner.wrapper

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory_wrapper.item_added.connect(_on_item_added)
	inventory_wrapper.item_removed.connect(_on_item_removed)
	inventory_wrapper.selected_changed.connect(_on_selected_changed)

func _on_item_added(item):
	var slot_instance = slot.instantiate()
	slot_instance.item_reference = item
	slot_instance.icon = item.item_icon
	add_child(slot_instance)

func _on_item_removed(item):
	for slot in get_children():
		if slot.item_reference == item:
			slot.queue_free()
		
	# print(inventory_wrapper.inventory.items)

func _on_selected_changed(id):
	if get_child_count() > 0:
		for slot in get_children().size():
			if slot != id:
				get_children()[slot].retract()
			else: get_children()[id].expand()
	print(id)
