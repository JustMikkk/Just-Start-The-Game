extends App

@export var _bindow_starting_game: Bindow

var _is_big: bool = false
var _bindow_opened: bool = false


# overrides so it doesnt show up in taskbar and transform
func _ready() -> void:
	if GameManager.has_player_admin and GameManager.has_player_firewall and GameManager.has_player_scissors:
		bindow = _bindow_starting_game
	
	mouse_click.connect(_on_mouse_click)
	mouse_enter.connect(_on_mouse_enter)
	mouse_exit.connect(_on_mouse_exit)


func _open_bindow() -> void:
	if _bindow_opened: return
	_bindow_opened = true
	bindow.open_bindow()


func _on_scale_timer_timeout() -> void:
	if _tween_scale: return
	
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_scale.tween_property(_icon, "scale", Vector2.ONE if _is_big else Vector2(2, 2), 0.7)
	_tween_scale.tween_callback(func():
		_is_big = not _is_big
		_tween_scale = null
	)
