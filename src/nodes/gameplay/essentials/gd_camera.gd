extends Camera3D
class_name GameCamera

@export_range(0, 1) var sensitivity:float = 0.01

@onready var target = get_parent()

var player:Client
var player_has_died:bool = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	top_level = true
	MultiplayerMaster.client_connected.connect(_on_player)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if !player_has_died:
			rotate_camera(Vector2(-event.relative.x, -event.relative.y))

func _process(delta):
	if !player_has_died:
		position = target.global_position
		var look_vector = Vector2(-Input.get_axis("look_left", "look_right"), Input.get_axis("look_down", "look_up"))
		rotate_camera(look_vector * 4)

func rotate_camera(amount:Vector2):
	rotation.x += amount.y * sensitivity
	rotation.y += amount.x * sensitivity
	rotation.x = clamp(rotation.x, -PI / 2.1, PI / 2.1)

func _on_player(client):
	player = client
	player.died.connect(_on_player_death)
	
func _on_player_death():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player_has_died = true
	var death_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	death_tween.tween_property(self, 'position', global_position + Vector3.DOWN, 0.5).set_trans(Tween.TRANS_BOUNCE)
	
