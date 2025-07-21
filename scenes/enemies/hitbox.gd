extends Entity


func take_damage(amount: int, _direction: Vector2) -> void:
	get_parent().take_damage(amount, _direction)
