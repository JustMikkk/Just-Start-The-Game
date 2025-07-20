extends App


@export var _next_positions: Array[Vector2i]
@export var _is_looping: bool = false

var _position_index: int = 0


func _ready() -> void:
	mouse_click.connect(_on_mouse_click)


func _on_mouse_click() -> void:
	
	if not _double_click_timer.time_left:
		_double_click_timer.start()
		_click_indicator.show()
		return
	else:
		_click_indicator.hide()
	
	print("w")
	GameManager.player.set_enabled(not GameManager.player.is_enabled(), global_position)
	
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	_tween_scale.tween_property(self, "scale", Vector2.ZERO, 0.4)
	_tween_scale.tween_callback(func():
		global_position = _next_positions[_position_index]
		_position_index += 1
		
		if _position_index == _next_positions.size():
			if _is_looping:
				_position_index = 0
			else:
				hide()
				(func():
					$CollisionShape2D.disabled = true
				).call_deferred()
		)
	_tween_scale.tween_property(self, "scale", Vector2.ONE, 0.4)
