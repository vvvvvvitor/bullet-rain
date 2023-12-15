extends Panel

var item_reference:Item
var expanded = false
@onready @export var icon:Texture:
	get: return icon
	set(val):
		var thumbnail = $MarginContainer/Thumbnail
		icon = val
		thumbnail.texture = icon

var expand_tween:Tween
var retract_tween:Tween

func _ready():
	tree_exiting.connect(_on_exiting)

func expand():
	if !expanded:
		expand_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
		expand_tween.tween_property(self, "custom_minimum_size", Vector2.ONE * 32, 0.2).set_trans(Tween.TRANS_QUAD)
		expanded = true

func retract():
	if expanded:
		retract_tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
		retract_tween.tween_property(self, "custom_minimum_size", Vector2.ONE * 12, 0.2).set_trans(Tween.TRANS_QUAD)
		expanded = false

func _on_exiting():
	if expand_tween:
		expand_tween.stop()
		expand_tween = null
	if retract_tween:
		retract_tween.stop()
		retract_tween = null
