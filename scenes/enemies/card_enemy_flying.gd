extends Entity


var _is_locked_in: bool = false

var _tween_scale: Tween


@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var _lock_in_timer: Timer = $LockInTimer


func _ready() -> void:
	damage_taken.connect(_on_damage_taken)
	entity_died.connect(_on_death)
	
	await get_tree().create_timer(randf_range(0, 2)).timeout
	_lock_in_timer.start()


func _process(delta: float) -> void:
	if not _is_locked_in: 
		look_at(GameManager.get_player_global_pos())
		return
	
	if is_on_wall() or is_on_ceiling() or is_on_floor():
		velocity = Vector2.ZERO
		_reset_scale()
		
	move_and_slide()


func _reset_scale() -> void:
	_is_locked_in = false
	if _tween_scale:
		_tween_scale.kill()
	
	_lock_in_timer.start()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	_tween_scale.tween_property(_animated_sprite_2d, "scale", Vector2.ONE, 0.5)


func _on_damage_taken() -> void:
	_animated_sprite_2d.modulate = Color.RED
	velocity = Vector2.ZERO
	_reset_scale()
	await get_tree().create_timer(0.1).timeout
	_animated_sprite_2d.modulate = Color.WHITE


func _on_death() -> void:
	queue_free()


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body is Entity:
		body.take_damage(_damage, (body.global_position - global_position).normalized())


func _on_lock_in_timer_timeout() -> void:
	if _is_locked_in: return
	
	(func():
			$CollisionShape2D.disabled = true
	).call_deferred()
	
	_is_locked_in = true
	
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	_tween_scale.tween_property(_animated_sprite_2d, "scale", Vector2(0.7, 1.3), 1)
	_tween_scale.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	_tween_scale.tween_property(_animated_sprite_2d, "scale", Vector2(1.05, 0.95), 0.1)
	_tween_scale.tween_callback(func():
		look_at(GameManager.get_player_global_pos())
		velocity = (GameManager.get_player_global_pos() - global_position).normalized() * 500
	)
	_tween_scale.tween_property(_animated_sprite_2d, "scale", Vector2(1.1, 0.9), 0.1)
	_tween_scale.tween_callback(func():
		(func():
			$CollisionShape2D.disabled = false
		).call_deferred()
	)
