class_name Game
extends Node2D


var _desktopHolders: Array[DesktopHolder]
var _desktop_index: int = 0
var _is_moving: bool = false

var _tween_alpha: Tween

@onready var _blurred_bg_back: Sprite2D = $BlurredBG_Back
@onready var _blurred_bg_front: Sprite2D = $BlurredBG_Front



func _ready() -> void:
	for node in $Desktops.get_children():
		if node is DesktopHolder:
			_desktopHolders.append(node)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		_switch_desktop_scaling(1)
	elif Input.is_action_just_pressed("debug2"):
		_switch_desktop_scaling(-1)


func _switch_desktop_normal(dir: int) -> void:
	if _is_moving: return
	
	_is_moving = true
	
	for i in range(_desktopHolders.size()):
		_desktopHolders[i].position = Vector2(
				(i + _desktop_index) * 960,
				0
		)
	
	_desktop_index += dir
	
	for i in range(_desktopHolders.size()):
		var desktop_holder = _desktopHolders[i]
		
		var tween: Tween = get_tree().create_tween()
		
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR).set_parallel(true)
		
		tween.tween_property(desktop_holder, "position", Vector2(
				(i + _desktop_index) * 960,
				0
		), 0.5)
		tween.tween_property(GameManager.player, "position", Vector2(
				5 if dir == -1 else 955,
				GameManager.player.position.y
		), 0.5)
		
		tween.tween_callback(func():
			_is_moving = false
		)


func _switch_desktop_scaling(dir: int) -> void:
	if _is_moving: return
	
	_is_moving = true
	
	for i in range(_desktopHolders.size()):
		_desktopHolders[i].position = Vector2(
				0,
				(i + _desktop_index) * 640
			)
	
	_blurred_bg_front.modulate.a = 1
	_blurred_bg_back.modulate.a = 0
	
	
	_blurred_bg_front.texture = _desktopHolders[-_desktop_index].desktop.bg.texture
	_desktop_index += dir
	_blurred_bg_back.texture = _desktopHolders[-_desktop_index].desktop.bg.texture
		
	
	_tween_alpha = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	
	_tween_alpha.tween_property(_blurred_bg_front, "modulate:a", 0, 2.4)
	_tween_alpha.tween_property(_blurred_bg_back, "modulate:a", 1, 2.4)
	
	
	for i in range(_desktopHolders.size()):
		var desktop_holder = _desktopHolders[i]
		
		var tween: Tween = get_tree().create_tween()
		
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		tween.tween_property(desktop_holder.desktop, "scale", Vector2(0.75, 0.75), 0.7)
		
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(desktop_holder, "position", Vector2(
				0,
				(i + _desktop_index) * 640
		), 1)
		
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		tween.tween_property(desktop_holder.desktop, "scale", Vector2.ONE, 0.7)
		
		tween.tween_callback(func():
			_is_moving = false
		)
	
