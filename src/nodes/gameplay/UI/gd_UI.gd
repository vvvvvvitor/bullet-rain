extends Control

@onready @export var wrapper:InventoryWrapper
@export var cursor_texture:Texture2D

func _ready():
	if is_multiplayer_authority():
		visible = true
	else: visible = false

func _input(event):
	if is_multiplayer_authority():
		if event is InputEvent:
			if event.is_action_pressed("ui_hide"):
				visible = !visible

func _draw():
	draw_texture(cursor_texture, get_viewport_rect().size / 2 - cursor_texture.get_size() / 2, Color.WHITE)
