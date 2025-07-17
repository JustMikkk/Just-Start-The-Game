class_name DesktopsManager
extends Node2D


var desktop_index: int = 0

var _desktop_holders: Array[DesktopHolder]
var _is_moving: bool = false

var _tween_alpha: Tween
var _tween_player_scale: Tween

@onready var _blurred_bg_back: Sprite2D = $BlurredBG_Back
@onready var _blurred_bg_front: Sprite2D = $BlurredBG_Front


func _ready() -> void:
	for node in get_children():
		if node is DesktopHolder:
			_desktop_holders.append(node)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		_switch_desktop_with_app(desktop_index - 1)
	elif Input.is_action_just_pressed("debug2"):
		_switch_desktop_with_app(desktop_index + 1)


func go_to_desktop(index: int, with_app: bool) -> void:
	
	GameManager.current_desktop = _desktop_holders[index].desktop
	
	if with_app:
		_switch_desktop_with_app(index)
	else:
		_switch_desktop_normal(index)


func _switch_desktop_normal(new_index: int) -> void:
	if _is_moving: return
	if new_index == desktop_index: return
	
	var dir = new_index - desktop_index 
	
	_is_moving = true
	
	for i in range(_desktop_holders.size()):
		_desktop_holders[i].position = Vector2(
				i * 960 - desktop_index * 960, # - because we're going left
				0
		)
	
	desktop_index = new_index
	
	for i in range(_desktop_holders.size()):
		var desktop_holder = _desktop_holders[i]
		
		var tween: Tween = get_tree().create_tween()
		
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR).set_parallel(true)
		
		GameManager.player.freeze()
		tween.tween_property(desktop_holder, "position", Vector2(
				i * 960 - desktop_index * 960,
				0
		), 0.5)

		tween.tween_property(GameManager.player, "global_position", Vector2(
				5 if dir > 0 else 955,
				GameManager.player.global_position.y
		), 0.5)
		
		tween.tween_callback(func():
			_is_moving = false
			GameManager.player.unfreeze()
		)


func _switch_desktop_with_app(new_index: int) -> void:
	if _is_moving: return
	
	_is_moving = true
	
	for i in range(_desktop_holders.size()):
		_desktop_holders[i].position = Vector2(
				0,
				 i * 640 - desktop_index * 640
			)
	
	_blurred_bg_front.modulate.a = 1
	_blurred_bg_back.modulate.a = 0
	
	_blurred_bg_front.texture = _desktop_holders[desktop_index].desktop.bg.texture
	desktop_index = new_index
	_blurred_bg_back.texture = _desktop_holders[desktop_index].desktop.bg.texture
	
	_tween_alpha = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	
	_tween_alpha.tween_property(_blurred_bg_front, "modulate:a", 0, 2.4)
	_tween_alpha.tween_property(_blurred_bg_back, "modulate:a", 1, 2.4)
	
	GameManager.player.freeze()
	_tween_player_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
	_tween_player_scale.tween_property(GameManager.game.player_holder, "scale", Vector2(0.75, 0.75), 0.7)
	_tween_player_scale.tween_interval(1)
	_tween_player_scale.tween_property(GameManager.game.player_holder, "scale", Vector2.ONE, 0.7)
	
	_tween_player_scale.tween_callback(
		GameManager.player.unfreeze
	)
	
	
	for i in range(_desktop_holders.size()):
		var desktop_holder = _desktop_holders[i]
		
		var tween: Tween = get_tree().create_tween()
		
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		tween.tween_property(desktop_holder.desktop, "scale", Vector2(0.75, 0.75), 0.7)
		
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(desktop_holder, "position", Vector2(
				0,
				i * 640 - desktop_index * 640
		), 1)
		
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		tween.tween_property(desktop_holder.desktop, "scale", Vector2.ONE, 0.7)
		
		tween.tween_callback(func():
			_is_moving = false
			
		)
	
