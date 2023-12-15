extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_on_press)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_press():
	get_tree().quit()
