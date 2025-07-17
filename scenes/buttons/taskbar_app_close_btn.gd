class_name TaskbarAppCloseBtn
extends AButton


var _tween_pos: Tween
var _tween_icon: Tween
var _tween_scale: Tween

var _is_mouse_hovering: bool = false
var _is_up: bool = false

@onready var x_button: AButton = $Icon/XButton
@onready var _btn_bg: Sprite2D = $Icon
@onready var _x_sprite: Sprite2D = $Icon/XButton/Icon


func _ready() -> void:
	is_enabled = true
	
	mouse_enter.connect(_on_mouse_enter)
	
	mouse_exit.connect(_on_mouse_exit)
	
	x_button.mouse_click.connect(_on_x_btn_click)
	x_button.mouse_enter.connect(_on_x_btn_mouse_enter)
	x_button.mouse_exit.connect(_on_x_btn_mouse_exit)


func slide_up() -> void:
	if _is_up: return
	
	if _tween_pos:
		_tween_pos.kill()
	
	_tween_pos = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_pos.tween_property(_btn_bg, "position:y", -32, 0.8)
	_tween_pos.tween_callback(func():
			_is_up = true
	)


func slide_down() -> void:
	if _is_mouse_hovering: return
	
	if _tween_pos:
		_tween_pos.kill()
	
	_tween_pos = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_pos.tween_property(_btn_bg, "position:y", 0, 0.8)
	_tween_pos.tween_callback(func():
			_is_up = false
	)


func _on_mouse_enter() -> void:
	_is_mouse_hovering = true


func _on_mouse_exit() -> void:
	if not get_tree(): return
	
	_is_mouse_hovering = false
	slide_down()


func _on_x_btn_click() -> void:
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(_x_sprite, "scale", Vector2(0.8, 0.8), Config.APP_CLOSE_TIME)


func _on_x_btn_mouse_enter() -> void:
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(_x_sprite, "scale", Vector2(1.1, 1.1), 0.3)


func _on_x_btn_mouse_exit() -> void:
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(_x_sprite, "scale", Vector2.ONE, 0.3)
	
