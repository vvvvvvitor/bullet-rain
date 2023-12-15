extends RayCast3D

@onready var camera = get_parent()

func _ready():
	add_exception(owner)

signal interacted_picked
signal interacted_left
var interact:Interactable

func _unhandled_input(event):
	if event is InputEvent:
		if Input.is_action_just_released("action_interact"):
			if interact:
				interact.emit_signal("interacted", owner)

func _process(delta):
	if is_colliding():
		if get_collider() is Interactable:
			if interact != get_collider():
				interact = get_collider()
				emit_signal("interacted_picked", interact)
	else:
		if interact:
			emit_signal("interacted_left", interact)
			interact = null
				
#	if inventory.inventory.items.size() > 0:
#		inventory.inventory.items[inventory.selected_item].can_use = false

#func _on_interactable_left(item):
#	item_in_sight = null
#	if inventory.inventory.items.size() > 0:
#		inventory.inventory.items[inventory.selected_item].can_use = true
