extends CharacterBody3D
class_name Entity

enum STATE {
	ALIVE,
	DEAD
}

var state = STATE.ALIVE

enum PHYSICS_STATES {
	AIR,
	STANDING
}
var physics_state = PHYSICS_STATES.AIR

signal damaged_changed
signal died
var damaged = 0:
	get: return damaged
	set(val):
		emit_signal('damaged_changed', damaged)
		if damaged > max_damaged:
			if state != STATE.DEAD:
				set_physics_process(false)
				emit_signal("died")
				state = STATE.DEAD
		else:
			damaged = val

			state = STATE.ALIVE
			set_physics_process(true)
			
@export var max_damaged:int = 10
@export var gravity:int = -15

func _init():
	name = "Entity"

func call_physics(delta:float = 1.0):
	match physics_state:
		PHYSICS_STATES.AIR:
			velocity.y += gravity * delta
			
			move_and_slide()
			
			if is_on_floor():
				velocity.y = 0
				physics_state = PHYSICS_STATES.STANDING
				
		PHYSICS_STATES.STANDING:
			if !is_on_floor():
				physics_state = PHYSICS_STATES.AIR
