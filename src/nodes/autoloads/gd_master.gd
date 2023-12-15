extends Node

var local_client:Client
signal paused
var game_paused:bool = false:
	get: return game_paused
	set(val):
		game_paused = val
		get_tree().paused = game_paused
		emit_signal("paused", game_paused)
var can_pause = true

signal quitting_changed
var quitting:bool = false

func _init():
	process_mode = Node.PROCESS_MODE_ALWAYS

var quit_duration:SceneTreeTimer
func _unhandled_input(event):
	if can_pause:
		if event is InputEvent:
			if event.is_action_released("action_start"):
				game_paused = !game_paused
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if !game_paused else Input.MOUSE_MODE_VISIBLE
				if quit_duration:
					quit_duration = null
					quitting = false
					emit_signal("quitting_changed", quitting)
	if game_paused:
		if event.is_action_pressed("action_start"):
			quit_duration = get_tree().create_timer(1)
			quit_duration.timeout.connect(_on_quit)
			quitting = true
			emit_signal("quitting_changed", quitting)

func _on_quit():
	if quit_duration:
		get_tree().quit()
