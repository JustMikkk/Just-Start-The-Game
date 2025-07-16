extends AButton

@export var _parent: Node2D
@export var _bindow_size: Vector2i

var _drag_offset: Vector2 = Vector2.ZERO
var _is_dragged: bool = false
var _is_mouse_in: bool = false


func _ready() -> void:
	mouse_enter.connect(_on_mouse_enter)
	mouse_exit.connect(_on_mouse_exit)
	mouse_click.connect(_on_mouse_click)
	


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_released("click"):
		_is_dragged = false

	if not _is_dragged: return
	
	var goal_pos: Vector2 = CursorManager.get_global_pos() + _drag_offset
	
	var pos_x: int = floor(clamp(goal_pos.x, _bindow_size.x / 2.0, Config.GAME_WIDTH - (_bindow_size.x / 2.0)))
	var pos_y: int = floor(clamp(goal_pos.y, _bindow_size.y / 2.0, Config.GAME_HEIGHT - (_bindow_size.y / 2.0) - 48))
	
	_parent.global_position = Vector2(int(pos_x), int(pos_y))




func _on_mouse_enter() -> void:
	_is_mouse_in = true


func _on_mouse_exit() -> void:
	_is_mouse_in = false


func _on_mouse_click() -> void:
	_is_dragged = true
	_drag_offset = _parent.global_position - CursorManager.get_global_pos()
