extends Control


func _ready():
	Master.paused.connect(_on_pause)
	visible = Master.game_paused
	
func _on_pause(val):
	visible = val
