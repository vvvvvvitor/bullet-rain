extends TextureRect
class_name InputImage

@export var action_name:String

func _input(event):
	if event is InputEvent:
		if event.is_action_pressed(action_name):
			texture.region = Rect2(texture.region.size.x, 0, texture.region.size.x, texture.region.size.y)
		if event.is_action_released(action_name):
			texture.region = Rect2(0, 0, texture.region.size.x, texture.region.size.y)
