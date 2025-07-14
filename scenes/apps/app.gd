class_name App
extends Area2D

signal app_opened_signal(icon: App)
signal app_closed_signal(icon: App)


@export var _is_fullcreen: bool = false
@export var bindow: Bindow
@export var taskbar_icon: Texture
@export var icon: Texture

var is_open: bool = false
var is_minimised: bool = false

var _tween_scale: Tween

@onready var _icon: Sprite2D = $Icon
@onready var _click_indicator: Sprite2D = $ClickIndicator
@onready var _double_click_timer: Timer = $DoubleClickTimer


func _ready() -> void:
	bindow.setup(global_position)
	bindow.bindow_close_signal.connect(_on_bindow_close)
	_icon.texture = icon


func _on_bindow_close() -> void:
	app_closed_signal.emit(self)


func _start_bindow() -> void:
	bindow.open_bindow()
	app_opened_signal.emit(self)


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
	Config.set_cursor_type(CursorType.CURIOUS)
	
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(_icon, "scale", Vector2(1.1, 1.1), 0.3)


func _on_mouse_exited() -> void:
	Config.set_cursor_type(CursorType.DEFAULT)
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(_icon, "scale", Vector2.ONE, 0.3)


func _on_double_click_timer_timeout() -> void:
	_click_indicator.hide()
