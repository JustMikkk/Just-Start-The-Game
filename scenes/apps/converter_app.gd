extends Node2D


@export var _next_positions: Array[Vector2i]
@export var _is_looping: bool = false

var _position_index: int = 0


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Player: return
	
	GameManager.player.set_enabled(false, global_position)
	global_position = _next_positions[_position_index]
	_position_index += 1
	if _position_index -1 == _next_positions.size():
		if _is_looping:
			_position_index = 0
		else:
			hide()
			(func():
				$Area2D/CollisionShape2D.disabled = true
			).call_deferred()
	
