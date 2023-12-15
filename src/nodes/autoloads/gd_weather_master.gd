extends Node

const WEATHERS = [
	{'id': 'clear', 'maxd': 10, 'mind': 10},
	{'id': 'rain', 'maxd': 5, 'mind': 10}
]

signal weather_changed
var weather = WEATHERS[0]:
	get: return weather
	set(val):
		weather = val
		emit_signal("weather_changed", weather)
var tick:int = 0
var time:float = 0
var clear_time:int = 0

func _process(delta):
	if weather == WEATHERS[0]:
		tick = (tick + 1) % 128
		if tick == 0:
			if randi_range(0, 1) == 1:
				weather = WEATHERS[randi_range(1, WEATHERS.size()-1)]
				clear_time = randf_range(weather['mind'], weather['maxd'])
	else:
		time += delta
		if time > clear_time:
			weather = WEATHERS[0]
			time = 0
		
	## print(weather, tick, time)
