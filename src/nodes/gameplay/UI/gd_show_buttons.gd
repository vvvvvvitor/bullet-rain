extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(_on_visible)
	for item in get_children():
		item.visible = false
	
func _on_visible():
	if visible:
		await get_tree().create_timer(1).timeout
		for item in get_children():
			await get_tree().create_timer(1).timeout
			item.visible = true
