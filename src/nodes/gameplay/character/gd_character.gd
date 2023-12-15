extends Entity
class_name Client

@onready var camera:GameCamera
@onready var shape = $Shape
@onready var item_offset = $CameraOffset/Camera/ItemOffset
@onready var interact_ray = $CameraOffset/Camera/InteractRay

enum MOVEMENT_STATES {
	IDLE,
	MOVING,
	JUMPING
}
enum ACTION_STATES {
	WALKING,
	RUNNING,
	CROUCHING
}
var action_state = ACTION_STATES.WALKING
var movement_state = MOVEMENT_STATES.IDLE

@export var ground_speed:float = 10
@export_range(0, 1) var ground_friction:float = 0.9
@export var jump_force:float = 5
@export var hunger_max = 100
@onready @export var inventory:InventoryWrapper

var crouching:bool = false
var direction:Vector3 = Vector3.ZERO
var last_direction:Vector3 = Vector3.ZERO

signal hunger_changed
var hunger = 0:
	get: return hunger
	set(val):
		hunger = clamp(val, 0, hunger_max)
		emit_signal("hunger_changed", hunger)
var jump_released = false
@onready var change_tween:Tween

func _ready():
	MultiplayerMaster.local_client = self
	camera = $CameraOffset/Camera
	
	camera.current = true
	inventory.selected_changed.connect(_on_select_change)
	
func _unhandled_input(event):
	if event is InputEvent:
		if event.is_action_pressed("action_crouch"):
			shape.scale.y = 0.5
			ground_speed = 5
			
		if event.is_action_released("action_crouch"):
			shape.scale.y = 1
			ground_speed = 10
			
#		if Input.is_action_just_released("action_interact"):
#			if item_in_sight:
#				var result = inventory.add_item(item_in_sight)
				
		if Input.is_action_pressed("action_drop"):
			if !inventory.inventory.items.is_empty():
				drop(inventory.selected_item, item_offset.global_position)

func drop(index:int, pos):
	if change_tween:
		change_tween.stop()
	var item:Item = inventory.get_item(index)
	item.position = pos
	item.rotation = item_offset.global_rotation
	item.freeze = false
	item.enabled = false
	item.apply_impulse(-camera.basis.z * 2)
	inventory.remove_item(index)
	get_tree().get_current_scene().add_child(item)

#@rpc
#func remote_drop_item(item, pos):
#	print(item)
#	drop(item, pos)

func _physics_process(delta):
	#print(damaged)
	
	#if is_multiplayer_authority():
	rotation.y = camera.rotation.y
	
	var inputs:Vector2 = Vector2(
		Input.get_axis("move_right", 'move_left'), 
		Input.get_axis("move_backwards", 'move_forward')
		)
	
	if inputs.length() > 0:
		direction = Vector3(
			(camera.basis.z.x * inputs.y) + (camera.basis.x.x * inputs.x), 
			0, 
			(camera.basis.z.z * inputs.y) + (camera.basis.x.z * inputs.x)
			)

	call_physics(delta)
	match movement_state:
		MOVEMENT_STATES.IDLE:
			if inputs.length() > 0:
				movement_state = MOVEMENT_STATES.MOVING
			
			apply_friction(ground_friction)

			if Input.is_action_just_pressed('action_jump'):
				jump(jump_force)
	
		MOVEMENT_STATES.MOVING:
			match action_state:
				ACTION_STATES.WALKING:
					apply_friction(ground_friction)
					apply_movement(direction, ground_speed, delta)
			
					if Input.is_action_pressed("action_run") && hunger != hunger_max:
						action_state = ACTION_STATES.RUNNING
				
				ACTION_STATES.RUNNING:
					apply_friction(ground_friction)
					apply_movement(direction, ground_speed * 2, delta)
					
					if Input.is_action_just_released("action_run") || hunger == hunger_max:
						action_state = ACTION_STATES.WALKING

			if inputs.length() == 0:
				movement_state = MOVEMENT_STATES.IDLE
				action_state = ACTION_STATES.WALKING

			if Input.is_action_just_pressed('action_jump'):
				jump(jump_force)
	
		MOVEMENT_STATES.JUMPING:
			if is_on_floor():
				jump_released = false
				movement_state = MOVEMENT_STATES.IDLE
				
			if !jump_released:
				if Input.is_action_just_released("action_jump"):
					velocity.y *= 0.5
					jump_released = true
					
	#rpc("remote_set_position", global_position, global_rotation)

#@rpc(unreliable)
#func remote_set_position(pos, rot):
#	global_position = pos
#	rotation = rot

func jump(force):
	apply_movement(-Vector3.UP, force, 1)
	movement_state = MOVEMENT_STATES.JUMPING


func apply_movement(direction:Vector3, speed:float, delta:float):
	velocity += -direction.normalized() * speed * delta
	move_and_slide()
	

func apply_friction(friction:float):
	if physics_state == PHYSICS_STATES.STANDING:
		velocity *= friction
		move_and_slide()


#func _on_interactable_picked(item):
#	item_in_sight = item
#	if inventory.inventory.items.size() > 0:
#		inventory.inventory.items[inventory.selected_item].can_use = false

#func _on_interactable_left(item):
#	item_in_sight = null
#	if inventory.inventory.items.size() > 0:
#		inventory.inventory.items[inventory.selected_item].can_use = true
	
func _on_select_change(item):
	if item_offset.get_child_count() > 0:
		for old_item in item_offset.get_children():
			old_item.stop_consuming()
			old_item.get_parent().remove_child(old_item)
	
	if !inventory.inventory.items.is_empty():
		var item_instance = inventory.inventory.items[item]
		if change_tween:
			change_tween.stop()

		item_instance.freeze = true
		item_instance.enabled = true
		item_instance.position = Vector3.DOWN * 0.5
		item_instance.rotation = Vector3.ZERO
		item_offset.add_child(item_instance)
		change_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
		change_tween.tween_property(item_instance, "position", Vector3.ZERO, 1).set_trans(Tween.TRANS_ELASTIC)
	pass
	
