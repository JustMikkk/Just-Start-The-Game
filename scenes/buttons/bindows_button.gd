extends AButton


var _tween_rotation: Tween
var _tween_scale: Tween

@onready var _icon: Sprite2D = $Icon


func _ready() -> void:
	mouse_click.connect(_animate)


func _animate() -> void:
	if _tween_rotation:
		_tween_rotation.kill()
	
	_tween_rotation = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_rotation.tween_property(_icon, "rotation_degrees", _icon.rotation_degrees - 180, 0.5)
	
	
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(_icon, "scale", _icon.scale + Vector2(1.01, 1.01), 0.15)
	_tween_scale.tween_interval(0.2)
	_tween_scale.tween_property(_icon, "scale", Vector2.ONE, 0.15)
	
