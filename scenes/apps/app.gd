class_name App
extends AButton

signal app_opened_signal(icon: App)
signal app_exitd_signal(icon: App)


#@export var _is_fullcreen: bool = false
@export var bindow: Bindow
@export var taskbar_icon: Texture
@export var icon: Texture
@export var _label_text: String

var is_open: bool = false
var is_minimised: bool = false

var _tween_scale: Tween

@onready var _icon: Sprite2D = $Icon
@onready var _click_indicator: Sprite2D = $ClickIndicator
@onready var _double_click_timer: Timer = $DoubleClickTimer
@onready var _label: Label = $Control/Label


func _ready() -> void:
	mouse_click.connect(_on_mouse_click)
	mouse_enter.connect(_on_mouse_enter)
	mouse_exit.connect(_on_mouse_exit)
	
	bindow.setup(position)
	bindow.bindow_exit_signal.connect(_on_bindow_exit)
	_icon.texture = icon
	_label.text = _label_text


func _on_bindow_exit() -> void:
	app_exitd_signal.emit(self)


func _open_bindow() -> void:
	bindow.open_bindow()
	app_opened_signal.emit(self)


func _on_mouse_click() -> void:
	if not _double_click_timer.time_left:
		_double_click_timer.start()
		_click_indicator.show()
	else:
		_click_indicator.hide()
		_open_bindow()
		
		GameManager.player.set_enabled(true, global_position)
		

func _on_mouse_enter() -> void:
	CursorManager.set_cursor_type(CursorType.CURIOUS)
	
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(_icon, "scale", Vector2(1.1, 1.1), 0.3)


func _on_mouse_exit() -> void:
	CursorManager.set_cursor_type(CursorType.DEFAULT)
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(_icon, "scale", Vector2.ONE, 0.3)


func _on_double_click_timer_timeout() -> void:
	_click_indicator.hide()
