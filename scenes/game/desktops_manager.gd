class_name DesktopsManager
extends Node2D


var desktop_index: int = 0

var _desktop_holders: Array[DesktopHolder]
var _is_moving: bool = false

var _tween_alpha: Tween

@onready var _blurred_bg_back: Sprite2D = $BlurredBG_Back
@onready var _blurred_bg_front: Sprite2D = $BlurredBG_Front


func _ready() -> void:
	for node in get_children():
		if node is DesktopHolder:
			_desktop_holders.append(node)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		_switch_desktop_normal(1)
	elif Input.is_action_just_pressed("debug2"):
		_switch_desktop_normal(3)


func go_to_desktop(index: int, with_app: bool) -> void:
	
	GameManager.current_desktop = _desktop_holders[index].desktop
	
	if with_app:
		_switch_desktop_with_app(index)
	else:
		_switch_desktop_normal(index)


func _switch_desktop_normal(new_index: int) -> void:
	if _is_moving: return
	
	var dir = desktop_index - new_index
	
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
		
		tween.tween_property(desktop_holder, "position", Vector2(
				i * 960 - desktop_index * 960,
				0
		), 0.5)
		tween.tween_property(GameManager.player, "position", Vector2(
				5 if dir < 0 else 955,
				GameManager.player.position.y
		), 0.5)
		
		tween.tween_callback(func():
			_is_moving = false
		)


func _switch_desktop_with_app(new_index: int) -> void:
	if _is_moving: return
	
	_is_moving = true
	
	for i in range(_desktop_holders.size()):
		_desktop_holders[i].position = Vector2(
				0,
				 i * 640 - desktop_index * 640
			)
			# i0  0, 640, 1280
			# i1  0 - 640, 0,  
		print(str(_desktop_holders[i].name, " pos ", _desktop_holders[i].position))
	
	_blurred_bg_front.modulate.a = 1
	_blurred_bg_back.modulate.a = 0
	
	_blurred_bg_front.texture = _desktop_holders[desktop_index].desktop.bg.texture
	desktop_index = new_index
	_blurred_bg_back.texture = _desktop_holders[desktop_index].desktop.bg.texture
	
	_tween_alpha = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	
	_tween_alpha.tween_property(_blurred_bg_front, "modulate:a", 0, 2.4)
	_tween_alpha.tween_property(_blurred_bg_back, "modulate:a", 1, 2.4)
	
	
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
			
			for d in _desktop_holders:
				print(str(d.name, " pos ", d.position))
				
		)
	
