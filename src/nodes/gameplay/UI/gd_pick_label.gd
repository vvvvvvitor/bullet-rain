extends Label

func _ready():
	get_parent().visible = false
	MultiplayerMaster.client_connected.connect(_on_client_connected)
	#get_viewport().get_camera_3d().interacted_picked.connect(_on_item_left)

func _on_client_connected(client):
	if client == MultiplayerMaster.local_client:
		MultiplayerMaster.local_client.interact_ray.interacted_picked.connect(_on_item_enter)
		MultiplayerMaster.local_client.interact_ray.interacted_left.connect(_on_item_left)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_item_enter(interaction):
	get_parent().visible = true
	text = interaction.action + " " + interaction.description.to_upper()
	var show_tween = get_tree().create_tween()
	show_tween.tween_property(self, "visible_ratio", 1.1, 0.2)
	
func _on_item_left(item):
	get_parent().visible = false
	visible_ratio = 0
