extends Node
class_name InventoryController

func _init():
	name = "InventoryController"

@export var wrapper:Node

func _input(event):
	if event is InputEvent:
		if event.is_action_pressed("action_next"):
			wrapper.selected_item += 1
		if event.is_action_pressed("action_back"):
			wrapper.selected_item -= 1
