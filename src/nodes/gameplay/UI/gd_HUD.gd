extends VBoxContainer


func _ready():
	MultiplayerMaster.client_connected.connect(_on_player)
	

func _on_player(client):
	client.died.connect(_on_death)
	

func _on_death():
	visible = false
