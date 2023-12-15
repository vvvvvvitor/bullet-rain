extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	Master.quitting_changed.connect(_on_quit)
	visible = Master.quitting

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_quit(quitting):
	visible = quitting
