class_name Bindow
extends Node2D

signal bindow_open_signal
signal bindow_close_signal
signal bindow_minimise_signal

enum BindowState {
	CLOSED,
	OPENED,
	MINIMISED,
}

@export var _size: Vector2i = Vector2(192, 192)


var current_state: BindowState = BindowState.CLOSED

var _origin_pos: Vector2
var _previouis_pos: Vector2

var _drag_offset: Vector2 = Vector2.ZERO
var _is_dragged: bool = false

var _tween_size: Tween

@onready var _minimise_btn: AButton = $MinimiseBtn
@onready var _exit_btn: AButton = $ExitBtn


func _ready() -> void:
	_minimise_btn.mouse_click.connect(_on_minimise_button_click)
	_exit_btn.mouse_click.connect(_on_exit_button_click)
	
	_previouis_pos = global_position
	if current_state == BindowState.CLOSED: 
		scale = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if not _is_dragged: return
	
	var goal_pos: Vector2 = get_global_mouse_position() + _drag_offset
	
	var pos_x: int = floor(clamp(goal_pos.x, _size.x / 2.0, Config.GAME_WIDTH - (_size.x / 2.0)))
	var pos_y: int = floor(clamp(goal_pos.y, _size.y /2.0, Config.GAME_HEIGHT - (_size.y / 2.0) - 48))
	
	global_position = Vector2(int(pos_x), int(pos_y))
	#global_position = Vector2(int(pos_x) - int(pos_x) % 16, int(pos_y) - int(pos_y) % 16)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				_is_dragged = false
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				#GameManager.enable_player(get_global_mouse_position(), false)
				Input.warp_mouse(GameManager.player.global_position)
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func setup(starting_pos: Vector2) -> void:
	_origin_pos = starting_pos


func open_bindow() -> void:
	_change_state(BindowState.OPENED)


func minimise_bindow() -> void:
	_change_state(BindowState.MINIMISED)


func close_bindow() -> void:
	_change_state(BindowState.CLOSED)


func is_open() -> bool:
	return current_state == BindowState.OPENED


func _change_state(new_state: BindowState) -> void:
	if current_state == new_state: return
	
	if current_state == BindowState.OPENED:
		_close_bindow()
	
	match new_state:
		BindowState.OPENED:
			_open_bindow()
			bindow_open_signal.emit()
		BindowState.CLOSED:
			bindow_close_signal.emit()
		BindowState.MINIMISED:
			bindow_minimise_signal.emit()
	
	current_state = new_state


func _open_bindow() -> void:
	global_position = _origin_pos
	scale = Vector2.ZERO
	
	if _tween_size:
		_tween_size.kill()
	
	_tween_size = get_tree().create_tween() \
			.set_ease(Tween.EASE_OUT) \
			.set_trans(Tween.TRANS_QUART) \
			.set_parallel(true)
	_tween_size.tween_property(self, "global_position", _previouis_pos, 0.8)
	_tween_size.tween_property(self, "scale", Vector2.ONE, 0.8)


func _close_bindow() -> void:
	_previouis_pos = global_position
	
	if _tween_size:
		_tween_size.kill()
	
	_tween_size = get_tree().create_tween() \
			.set_ease(Tween.EASE_OUT) \
			.set_trans(Tween.TRANS_QUART) \
			.set_parallel(true)
	_tween_size.tween_property(self, "global_position", _origin_pos, 0.8)
	_tween_size.tween_property(self, "scale", Vector2.ZERO, 0.8)


func _on_drag_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				_drag_offset = global_position - get_global_mouse_position()
				_is_dragged = true


func _on_minimise_button_click() -> void:
	minimise_bindow()


func _on_exit_button_click() -> void:
	close_bindow()
