extends Node2D


@export var _alert_before_appear: AlertBindow
@export var _alert_after_appear: AlertBindow
@export var _alert_before_leave: AlertBindow
@export var _alert_after_leave: AlertBindow


var _tween_pos: Tween

@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var _gpu_particles_2d: GPUParticles2D = $"../GPUParticles2D"
@onready var _point_light_2d: PointLight2D = $"../PointLight2D"

func _ready() -> void:
	_alert_before_appear.alert_exit_signal.connect(_appear)
	_alert_before_leave.alert_exit_signal.connect(_leave)


func _appear() -> void:
	_animated_sprite_2d.play("appear")
	await _animated_sprite_2d.animation_finished
	call_deferred("_enable_collisions")
	
	_tween_pos = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	_tween_pos.tween_interval(0.7)
	_tween_pos.tween_property(self, "position", Vector2(-160, -88), 0.7)
	_tween_pos.tween_callback(func():
			_alert_after_appear.open_bindow()
	)


func _leave() -> void:
	CursorManager.freeze()
	_tween_pos = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	_tween_pos.tween_interval(0.7)
	_tween_pos.tween_property(GameManager.game.camera, "zoom", Vector2(2, 2), 0.8)
	_tween_pos.tween_callback(func():
		GameManager.player.set_enabled(true, CursorManager.get_global_pos()) 
	)
	_tween_pos.tween_interval(0.7)
	_tween_pos.tween_property(GameManager.game.camera, "zoom", Vector2.ONE, 0.8)
	_tween_pos.tween_interval(0.7)
	_tween_pos.tween_property(self, "position", Vector2(96, -160), 0.7)
	_tween_pos.tween_interval(0.3)
	_tween_pos.tween_callback(func():
		_alert_after_leave.open_bindow()
	)
	_tween_pos.tween_interval(4)
	_tween_pos.tween_property(self, "rotation_degrees", 90, 1)
	_tween_pos.tween_interval(0.3)
	_tween_pos.tween_callback(func():
		GameManager.game.camera.add_trauma(0.5)
		await get_tree().create_timer(0.1).timeout
		_gpu_particles_2d.restart()
		await get_tree().create_timer(0.1).timeout
		
	)
	_tween_pos.tween_property(self, "position", Vector2(584, -160), 0.2)
	_tween_pos.tween_property(_point_light_2d, "energy", 2, 3)


func _enable_collisions() -> void:
	$StaticBody2D/CollisionShape2D.disabled = false 
	$StaticBody2D/CollisionShape2D2.disabled = false 
	$StaticBody2D/CollisionShape2D3.disabled = false
