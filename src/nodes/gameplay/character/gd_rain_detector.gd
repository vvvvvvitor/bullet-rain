extends RayCast3D

@export var target:Entity
@export var damage_rate:Timer
@export var damage_amount = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	damage_rate.timeout.connect(_on_stop)
	
func _on_stop():
	if WeatherMaster.weather == WeatherMaster.WEATHERS[1]:
		if !is_colliding():
			target.damaged += damage_amount
