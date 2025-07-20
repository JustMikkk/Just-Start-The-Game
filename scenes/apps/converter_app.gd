extends Node2D




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Player: return
	
	GameManager.player.set_enabled(false, global_position)
	
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
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
					$Area2D/CollisionShape2D.disabled = true
				).call_deferred()
		)
	_tween_scale.tween_property(self, "scale", Vector2.ONE, 0.4)
	
	
	
