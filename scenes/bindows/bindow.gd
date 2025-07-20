class_name Bindow
extends Node2D

signal bindow_open_signal
signal bindow_exit_signal
signal bindow_minimise_signal

enum BindowState {
	CLOSED,
	OPENED,
	MINIMISED,
}

@export var _can_be_minimised: bool = true
@export var _can_be_exited: bool = true

@export var current_state: BindowState = BindowState.CLOSED

var _origin_pos: Vector2
var _previouis_pos: Vector2

var _tween_size: Tween

@onready var _minimise_btn: AButton = $MinimiseBtn
@onready var _exit_btn: AButton = $ExitBtn

@onready var _collision_shape_2d: CollisionShape2D = $Bounds/CollisionShape2D
@onready var _collision_shape_2d_2: CollisionShape2D = $Bounds/CollisionShape2D2
@onready var _frame: Sprite2D = $Frame



func _ready() -> void:
	_minimise_btn.mouse_click.connect(_on_minimise_button_click)
	_exit_btn.mouse_click.connect(_on_exit_button_click)
	
	_previouis_pos = position
	if current_state == BindowState.CLOSED: 
		scale = Vector2.ZERO


func setup(starting_pos: Vector2) -> void:
	_origin_pos = starting_pos


func open_bindow() -> void:
	_change_state(BindowState.OPENED)


func minimise_bindow() -> void:
	_minimise_bindow(_minimise_btn.global_position)


func minimise_bindow_taskbar(pos: Vector2):
	_minimise_bindow(pos)


func exit_bindow() -> void:
	if not _can_be_exited: return
	
	GameManager.player.set_enabled(true, _exit_btn.global_position)
	
	_change_state(BindowState.CLOSED)


func is_open() -> bool:
	return current_state == BindowState.OPENED


func get_size() -> Vector2:
	return _frame.texture.get_size()


func _change_state(new_state: BindowState) -> void:
	if current_state == new_state: return
	
	if current_state == BindowState.OPENED:
		_exit_bindow()
		_collision_shape_2d.disabled = true
		_collision_shape_2d_2.disabled = true

	
	match new_state:
		BindowState.OPENED:
			_open_bindow()
			bindow_open_signal.emit()
			_collision_shape_2d.disabled = false
			_collision_shape_2d_2.disabled = false
		
		BindowState.CLOSED:
			bindow_exit_signal.emit()
		BindowState.MINIMISED:
			bindow_minimise_signal.emit()
	
	current_state = new_state


func _open_bindow() -> void:
	position = _origin_pos
	scale = Vector2.ZERO
	
	if _tween_size:
		_tween_size.kill()
	
	_tween_size = get_tree().create_tween() \
			.set_ease(Tween.EASE_OUT) \
			.set_trans(Tween.TRANS_QUART) \
			.set_parallel(true)
	_tween_size.tween_property(self, "position", _previouis_pos, 0.8)
	_tween_size.tween_property(self, "scale", Vector2.ONE, 0.8)


func _exit_bindow() -> void:
	if scale == Vector2.ONE:
		_previouis_pos = position
	
	if _tween_size:
		_tween_size.kill()
	
	_tween_size = get_tree().create_tween() \
			.set_ease(Tween.EASE_OUT) \
			.set_trans(Tween.TRANS_QUART) \
			.set_parallel(true)
	_tween_size.tween_property(self, "position", _origin_pos, 0.8)
	_tween_size.tween_property(self, "scale", Vector2.ZERO, 0.8)


func _minimise_bindow(pos: Vector2) -> void:
	if not _can_be_minimised: return
	
	GameManager.player.set_enabled(true, pos)
	
	_change_state(BindowState.MINIMISED)



func _on_minimise_button_click() -> void:
	minimise_bindow()


func _on_exit_button_click() -> void:
	exit_bindow()
