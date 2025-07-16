extends AButton

@export var _parent: Bindow

var _tween_alpha: Tween

var _bindow_size: Vector2i

var _drag_offset: Vector2 = Vector2.ZERO
var _is_dragged: bool = false:
	set(val):
		_is_dragged = val
		
		if _tween_alpha:
			_tween_alpha.kill()
		
		_tween_alpha = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		_tween_alpha.tween_property(_parent, "modulate:a", 0.8 if _is_dragged else 1, 0.3)


func _ready() -> void:
	await _parent.ready
	_bindow_size = _parent.get_size()

	mouse_click.connect(_on_mouse_click)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_released("click"):
		_is_dragged = false

	if not _is_dragged: return
	
	var goal_pos: Vector2 = CursorManager.get_global_pos() + _drag_offset
	
	var pos_x: int = floor(clamp(goal_pos.x, _bindow_size.x / 2.0, Config.GAME_WIDTH - (_bindow_size.x / 2.0)))
	var pos_y: int = floor(clamp(goal_pos.y, _bindow_size.y / 2.0, Config.GAME_HEIGHT - (_bindow_size.y / 2.0) - 48))
	
	_parent.global_position = Vector2(int(pos_x), int(pos_y))


func _on_mouse_click() -> void:
	_is_dragged = true
	_drag_offset = _parent.global_position - CursorManager.get_global_pos()
