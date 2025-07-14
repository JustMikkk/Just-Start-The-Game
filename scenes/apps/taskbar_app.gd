class_name TaskbarApp
extends AButton

var app: App
var _taskbar: Taskbar

var _tween_scale: Tween
var _tween_indicator: Tween
var _tween_location: Tween

@onready var _icon: Sprite2D = $Icon
@onready var _active_indicator: Sprite2D = $ActiveIndicator
@onready var _taskbar_app_close_btn: TaskbarAppCloseBtn = $TaskbarAppCloseBtn


func _ready() -> void:
	_icon.scale = Vector2.ZERO
	
	mouse_click.connect(_on_mouse_click)
	mouse_enter.connect(_on_mouse_enter)
	mouse_exit.connect(_on_mouse_exit)
	_taskbar_app_close_btn.x_button.mouse_click.connect(_on_close_btn_click)


func setup(_app: App, taskbar: Taskbar) -> void:
	app = _app
	_taskbar = taskbar
	
	app.bindow.bindow_open_signal.connect(_on_bindow_open)
	app.bindow.bindow_minimise_signal.connect(_on_bindow_minimise)
	app.bindow.bindow_close_signal.connect(_on_bindow_close)
	
	await ready
	
	_icon.texture = self.app.taskbar_icon
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_parallel(true)
	_tween_scale.tween_property(_icon, "scale", Vector2.ONE, 0.3)
	_tween_scale.tween_property(_icon, "rotation_degrees", 0, 0.3)
	
	await get_tree().create_timer(0.2).timeout
	
	_on_bindow_open()


func move_to_pos(pos: Vector2) -> void:
	if _tween_location:
		_tween_location.kill()
	
	_tween_location = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	_tween_location.tween_property(self, "position", pos, 0.4)


func _open_bindow() -> void:
	app.bindow.open_bindow()


func _minimise_bindow() -> void:
	app.bindow.minimise_bindow()


func _close_bindow() -> void:
	app.bindow.close_bindow()


func _on_mouse_click() -> void:
	if app.bindow.is_open():
		_minimise_bindow()
	else:
		_open_bindow()


func _on_mouse_enter() -> void:
	_taskbar_app_close_btn.slide_up()


func _on_mouse_exit() -> void:
	_taskbar_app_close_btn.slide_down()


func _on_bindow_open() -> void:
	if _tween_indicator:
		_tween_indicator.kill()
	
	_tween_indicator = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	_tween_indicator.tween_property(_active_indicator, "scale:x", 1, 0.4)
	_tween_indicator.tween_property(_active_indicator, "scale:y", 1, 0.2)


func _on_bindow_minimise() -> void:
	if _tween_indicator:
		_tween_indicator.kill()
	
	_tween_indicator = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	_tween_indicator.tween_property(_active_indicator, "scale:x", 0.1, 0.4)
	_tween_indicator.tween_property(_active_indicator, "scale:y", 0.2, 0.2)


func _on_bindow_close() -> void:
	_on_bindow_minimise()
	
	if _tween_scale:
		_tween_scale.kill()
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_parallel(true)
	_tween_scale.tween_property(_icon, "scale", Vector2.ZERO, Config.APP_CLOSE_TIME)
	_tween_scale.tween_property(_icon, "rotation_degrees", -180, Config.APP_CLOSE_TIME)
	
	
	app.bindow.bindow_open_signal.disconnect(_on_bindow_open)
	app.bindow.bindow_minimise_signal.disconnect(_on_bindow_minimise)
	app.bindow.bindow_close_signal.disconnect(_on_bindow_close)


func _on_close_btn_click() -> void:
	_close_bindow()
