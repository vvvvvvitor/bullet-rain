extends Label

func _ready():
	MultiplayerMaster.client_connected.connect(_on_client_connected)

func _on_client_connected(client):
	text = str(client.damaged).pad_zeros(2)
	if client:
		client.damaged_changed.connect(_damaged)
		client.died.connect(_dead)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _damaged(amount):
	material.set_shader_parameter("strength", amount + 10)
	text = str(amount).pad_zeros(2)

func _dead():
	material.set_shader_parameter("strength", 0)
	label_settings.font_color = Color.DIM_GRAY
	label_settings.shadow_color = Color.TOMATO
	material.set("shader_parameter/offset", 0)
	
