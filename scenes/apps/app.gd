class_name App
extends Area2D


@export var is_fullcreen: bool = false
@export var bindow: Bindow
@export var bindow_pos: Vector2

var is_open: bool = false
var is_minimised: bool = false

var _tween_scale: Tween

@onready var _icon: Sprite2D = $Icon
@onready var _click_indicator: Sprite2D = $ClickIndicator
@onready var _double_click_timer: Timer = $DoubleClickTimer


func _start_bindow() -> void:
	bindow.open_bindow(global_position, bindow_pos)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_pressed():
		if not _double_click_timer.time_left:
			_double_click_timer.start()
			_click_indicator.show()
		else:
			_click_indicator.hide()
			_start_bindow()


func _on_mouse_entered() -> void:
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(_icon, "scale", Vector2(1.1, 1.1), 0.3)


func _on_mouse_exited() -> void:
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(_icon, "scale", Vector2.ONE, 0.3)


func _on_double_click_timer_timeout() -> void:
	_click_indicator.hide()
