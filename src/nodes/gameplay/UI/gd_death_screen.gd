extends Control


func _ready():
	MultiplayerMaster.client_connected.connect(_on_player)
	#visible = false

func _on_player(client):
	client.died.connect(_on_death)
	

func _on_death():
	await get_tree().create_timer(1).timeout
	visible = true
