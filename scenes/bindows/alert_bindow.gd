class_name AlertBindow
extends TextBindow


signal alert_exit_signal

@export var _transforms_player: bool = true
@export_multiline var _btn_text: String = "OK"
@export var _next_bindow: AlertBindow


@onready var _btn_label: Label = $ExitBtn/BtnLabel


func _ready() -> void:
	super()
	
	_origin_pos = Vector2(Config.GAME_WIDTH /2, Config.GAME_HEIGHT /2)
	_previouis_pos = _origin_pos
	bindow_exit_signal.connect(_on_bindow_exit)
	
	_btn_label.text = _btn_text


func exit_bindow() -> void:
	if not _can_be_exited: return
	
	if _transforms_player: 
		GameManager.player.set_enabled(true, _exit_btn.global_position)
	
	_change_state(BindowState.CLOSED)


func _on_bindow_exit() -> void:
	if _next_bindow:
		_next_bindow.open_bindow()
	
	alert_exit_signal.emit()
	bindow_exit_signal.disconnect(_on_bindow_exit)
