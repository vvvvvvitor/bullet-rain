extends Node3D
class_name Weather

@onready var weathers = get_children()

var current_weather:Node
var last_weather:Node

func _ready():
	travel(0)
	#await get_tree().create_timer(1).timeout
	#travel(1)

func travel(next:int):
	last_weather = current_weather
	if last_weather:
		last_weather.visible = false
		last_weather.set_process(false)
	current_weather = weathers[next]
	
	weathers[next].set_process(true)
	weathers[next].visible = true
