extends Area2D

@export var _power_up_id: String
@export var _texture: Texture

var _tween_pos: Tween

var _going_up: bool = false

func _ready() -> void:
	$Sprite2D.texture = _texture
	
	if GameManager.has_player_power_up(_power_up_id):
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if not GameManager.player.is_enabled(): return
	
	GameManager.add_power_up(_power_up_id, global_position, _texture)
	queue_free()


func _on_timer_timeout() -> void:
	_going_up = not _going_up
	_tween_pos = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_parallel(true)
	_tween_pos.tween_property(self, "scale", Vector2(1.1, 1.1) if not _going_up else Vector2.ONE, 0.8)
	_tween_pos.tween_property(self, "position", position + Vector2(0, 15) if _going_up else position - Vector2(0, 15), 0.8)
	
