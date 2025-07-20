extends Area2D


var _tween_scale: Tween


func _ready() -> void:
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	_tween_scale.tween_property(self, "scale", Vector2.ONE, 0.7)
	#_tween_scale.tween_property(self, "rotation_degrees", 0, 0.7)


func _on_body_entered(body: Node2D) -> void:
	if body is Entity:
		body.take_damage(999, Vector2.ZERO)
