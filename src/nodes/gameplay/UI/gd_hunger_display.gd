extends Label

func _ready():
	MultiplayerMaster.client_connected.connect(_on_client_connected)

func _on_client_connected(client):
	text = str(client.hunger).pad_zeros(2)
	if client:
		client.hunger_changed.connect(_hunger_changed)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _hunger_changed(amount):
	material.set_shader_parameter("strength", amount + 10)
	text = str(amount).pad_zeros(2)
