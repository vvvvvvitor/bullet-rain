extends Node3D

@export var cloud_height:float = 80
@onready var camera = get_viewport().get_camera_3d()

func _physics_process(delta):
	if get_viewport().get_camera_3d():
		position = Vector3(get_viewport().get_camera_3d().global_position.x, cloud_height, get_viewport().get_camera_3d().global_position.z)
