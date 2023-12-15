extends GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready():
	WeatherMaster.weather_changed.connect(_on_weather)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_weather(weather):
	emitting = weather["id"] == "rain"
