extends Entity

const SHIELD = preload("res://scenes/bindows_defender/shield.tscn")

@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var _positions: Array[Vector2]
@export var _rotations: Array[float]

var _tween_pos: Tween
var _pos_index: int = 0

var shield

func _ready() -> void:
	damage_taken.connect(_on_damage_taken)


func start_charge_timer() -> void:
	$ChargeTimer.start()


func stop_fighting() -> void:
	if shield:
		shield.queue_free()
	
	$ChargeTimer.stop()
	(func():
		$DamageArea/CollisionShape2D
		$DamageArea/CollisionShape2D2
		$DamageArea/CollisionShape2D3
		$DamageArea/CollisionShape2D4
	).call_deferred()





func _on_damage_taken() -> void:
	_animated_sprite_2d.modulate = Color.RED
	GameManager.game.camera.add_trauma(0.2)
	if _health / 10.0 == 0.5:
		_animated_sprite_2d.play("battle")
		shield = SHIELD.instantiate()
		get_parent().add_child(shield)
		shield.global_position = global_position + Vector2(-48, 36)
	
	await get_tree().create_timer(0.1).timeout
	_animated_sprite_2d.modulate = Color.WHITE


func _on_damage_area_body_entered(body: Node2D) -> void:
	body.take_damage(1, Vector2.ZERO)


func _on_charge_timer_timeout() -> void:
	if _tween_pos:
		_tween_pos.kill()
	
	_tween_pos = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	_tween_pos.tween_property(self, "rotation_degrees", _rotations[_pos_index], 0.4)
	_tween_pos.tween_interval(0.2)
	_tween_pos.tween_property(self, "position", _positions[_pos_index], 0.8)
	_tween_pos.tween_callback(func():
		GameManager.game.camera.add_trauma(0.3)
	)
	
	_pos_index += 1
	if _pos_index == _positions.size():
		_pos_index = 0
