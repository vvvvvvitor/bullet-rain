extends RigidBody3D
class_name Item

@export @onready var item_icon:Texture2D
@export var is_consumable:bool = false
@export var satisfaction_value:int
@export var can_use:bool = true
@export var consumable:Consumable
var interact_area:Interactable
var eat_tween:Tween

var enabled:bool = false:
	get: return enabled
	set(val):
		enabled = val
		set_physics_process(val)
		set_process(val)
		set_process_input(val)
		set_collision_layer_value(1, !val)
		set_collision_mask_value(1, !val)

func _ready():
	for item in get_children():
		if item is Interactable:
			interact_area = item
			item.interacted.connect(_on_interaction)
			break
	
	if enabled == false:
		set_process(false)
		set_process_input(false)
		set_physics_process(false)


func _on_interaction(inflictor):
	if Input.is_action_just_released("action_interact"):
		inflictor.inventory.add_item(self)

signal item_used
func _input(event):
	if can_use:
		if event is InputEvent:
			if event.is_action_pressed("action_use"):
				emit_signal('item_used')
				if consumable:
					consume()
					
					
func consume():
	eat_tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	eat_tween.tween_property(self, "position", Vector3.BACK, consumable.consuming_duration).set_trans(Tween.TRANS_QUAD)
	await eat_tween.finished
	MultiplayerMaster.local_client.hunger -= consumable.satisfaction_value
	MultiplayerMaster.local_client.inventory.remove_item(MultiplayerMaster.local_client.inventory.selected_item)


func stop_consuming():
	if eat_tween:
		eat_tween.stop()
