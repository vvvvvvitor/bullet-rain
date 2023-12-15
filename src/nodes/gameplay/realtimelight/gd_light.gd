extends DirectionalLight3D

@export var env:WorldEnvironment

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation.x = fmod(rotation.x + (0.3 * delta), PI * 2)
	if rotation.x > PI:
		light_energy = sin((rotation.x / PI))
	else:
		light_energy = 0
