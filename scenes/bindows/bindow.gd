class_name Bindow
extends Node2D

enum BindowState {
	CLOSED,
	OPENED,
	MINIMISED,
}


var _is_dragged: bool = false
var _drag_offset: Vector2 = Vector2.ZERO

var _width: float = 192
var _height: float = 185

var _tween_size: Tween

var _origin_pos: Vector2
var _previouis_pos: Vector2


func _init() -> void:
	scale = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if not _is_dragged: return
	
	var goal_pos: Vector2 = get_global_mouse_position() + _drag_offset
	
	var pos_x: int = floor(clamp(goal_pos.x, _width / 2, Config.GAME_WIDTH - (_width / 2)))
	var pos_y: int = floor(clamp(goal_pos.y, _height /2, Config.GAME_HEIGHT - (_height / 2)))
	
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


func open_bindow(starting_pos: Vector2, goal_pos: Vector2):
	_origin_pos = starting_pos
	global_position = _origin_pos
	scale = Vector2.ZERO
	
	if _tween_size:
		_tween_size.kill()
	
	_tween_size = get_tree().create_tween() \
			.set_ease(Tween.EASE_OUT) \
			.set_trans(Tween.TRANS_QUART) \
			.set_parallel(true)
	_tween_size.tween_property(self, "global_position", goal_pos if not _previouis_pos else _previouis_pos, 0.8)
	_tween_size.tween_property(self, "scale", Vector2.ONE, 0.8)


func close_bindow():
	_previouis_pos = global_position
	
	if _tween_size:
		_tween_size.kill()
	
	_tween_size = get_tree().create_tween() \
			.set_ease(Tween.EASE_IN) \
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


func _on_close_button_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_pressed():
		close_bindow()


func _on_minimise_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
