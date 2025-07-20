class_name TransitionPlayer
extends Control


signal ready_for_change

var _tween_transition: Tween

@onready var _color_rect: ColorRect = $ColorRect


func play_death_transition() -> void:
	if _tween_transition:
		_tween_transition.kill()
	
	_color_rect.pivot_offset = Vector2.ZERO
	_color_rect.scale = Vector2(1, 0)
	GameManager.player.freeze()
	
	_tween_transition = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween_transition.tween_property(_color_rect, "scale:y", 1, 1)
	_tween_transition.tween_callback(func():
		ready_for_change.emit()
		_color_rect.pivot_offset = Vector2(0, 960)
	)
	_tween_transition.tween_property(_color_rect, "scale:y", 0, 1)
	_tween_transition.tween_callback(func():
		GameManager.player.unfreeze()
	)
