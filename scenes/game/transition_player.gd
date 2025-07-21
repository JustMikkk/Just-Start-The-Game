class_name TransitionPlayer
extends Control


signal ready_for_change

var _tween_transition: Tween
var _tween_pos: Tween

@onready var _color_rect: ColorRect = $ColorRect
@onready var _sprite_2d: Sprite2D = $Sprite2D
@onready var _label: Label = $ColorRect/Label


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


func play_power_up_transition(pos: Vector2, texture: Texture, destination: Vector2) -> void:
	#Engine.time_scale = 0
	
	_sprite_2d.scale = Vector2.ZERO
	_sprite_2d.texture = texture
	_sprite_2d.show()
	_sprite_2d.global_position = pos
	
	_tween_pos = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_ignore_time_scale(true).set_parallel(true)
	_tween_pos.tween_property(_sprite_2d, "global_position", Vector2(Config.GAME_WIDTH /2, Config.GAME_HEIGHT /2), 0.7)
	_tween_pos.tween_property(_sprite_2d, "scale", Vector2(3, 3), 0.7)
	_tween_pos.set_parallel(false)
	_tween_pos.tween_property(_sprite_2d, "scale", Vector2(-3, 3), 0.7)
	_tween_pos.tween_property(_sprite_2d, "scale", Vector2(3, 3), 0.7)
	_tween_pos.set_parallel(true)
	_tween_pos.tween_property(_sprite_2d, "global_position", destination, 0.7)
	_tween_pos.tween_property(_sprite_2d, "scale", Vector2(0.75, 0.75), 0.7)
	_tween_pos.set_parallel(false)
	_tween_pos.tween_callback(func():
		#_sprite_2d.hide()
		_sprite_2d.scale = Vector2.ZERO
		#Engine.time_scale = 1
		GameManager.current_desktop.taskbar.update_power_ups()
	)


func roll_the_courtain() -> void:
	if _tween_transition:
		_tween_transition.kill()
	
	_label.show()
	
	_color_rect.pivot_offset = Vector2.ZERO
	_color_rect.scale = Vector2(1, 0)

	_tween_transition = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween_transition.tween_property(_color_rect, "scale:y", 1, 1)
	
	
	
