extends Area2D


@export var is_disabled: bool = false
@export var icon: Texture

var _tween_scale: Tween

@onready var _sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	_sprite_2d.texture = icon


func _on_mouse_entered() -> void:
	if is_disabled: return
	
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(_sprite_2d, "scale", Vector2(1.1, 1.1), 0.3)


func _on_mouse_exited() -> void:
	if is_disabled: return
	
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(_sprite_2d, "scale", Vector2.ONE, 0.3)
