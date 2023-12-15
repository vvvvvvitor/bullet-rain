extends Timer

@export var depletion_amount = 10
@onready var client = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	timeout.connect(_on_timeout)
	
func _on_timeout():
	if client is Client:
		client.hunger += depletion_amount
		if client.hunger == client.hunger_max:
			if client.damaged < 50:
				client.damaged += 5
