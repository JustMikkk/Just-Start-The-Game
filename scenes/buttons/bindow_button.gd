extends AButton

@export var _icon: Texture

var _tween_scale: Tween

@onready var _sprite_2d: Sprite2D = $Icon


func _ready() -> void:
	mouse_enter.connect(_on_mouse_enter)
	mouse_exit.connect(_on_mouse_exit)
	
	_sprite_2d.texture = _icon


func _on_mouse_enter() -> void:
	
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(_sprite_2d, "scale", Vector2(1.1, 1.1), 0.3)


func _on_mouse_exit() -> void:
	
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(_sprite_2d, "scale", Vector2.ONE, 0.3)
