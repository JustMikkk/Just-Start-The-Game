extends Node2D

signal cursor_transformed

const MAX_SPEED = 400
const ACCELERATION = 200

var _speed: float = 0
var _is_cursor_hidden: bool = false

@onready var _previous_mouse_pos: Vector2 = get_global_mouse_position()

@onready var _cursor_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _click_area: ClickArea = $AnimatedSprite2D/ClickArea


func _ready() -> void:
	_click_area.is_enabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_cursor_type(CursorType.DEFAULT)


func _process(delta: float) -> void:
	if _is_cursor_hidden: return
	
	if get_global_mouse_position() != _previous_mouse_pos:
		_cursor_sprite.position = Vector2(7, 7)
		global_position = get_global_mouse_position()
	else:
		var dir: Vector2 = Input.get_vector("left", "right", "up", "down")
		
		if dir:
			_speed = move_toward(_speed, MAX_SPEED, ACCELERATION * delta)
		else:
			_speed = move_toward(_speed, 0, ACCELERATION * delta)
		
		_cursor_sprite.position += dir.normalized() * _speed * delta
	
	_cursor_sprite.global_position = Vector2(
			clamp(_cursor_sprite.global_position.x, 7, Config.GAME_WIDTH - 7),
			clamp(_cursor_sprite.global_position.y, 7, Config.GAME_HEIGHT - 7)
	)
	
	_previous_mouse_pos = get_global_mouse_position()


func is_cursor_hidden() -> bool:
	return _is_cursor_hidden


func show_warp_cursor(pos: Vector2) -> void:
	_warp_cursor(pos)
	_cursor_sprite.position = Vector2(7, 7)
	_is_cursor_hidden = false
	show_cursor() 


func show_cursor() -> void:
	_cursor_sprite.play("default")
	_cursor_sprite.show()
	_cursor_sprite.play("transform_into")
	await _cursor_sprite.animation_finished
	_click_area.is_enabled = true
	cursor_transformed.emit()
	_cursor_sprite.play("default")


func hide_cursor() -> void:
	_click_area.is_enabled = false
	_cursor_sprite.play("transform_from")
	await _cursor_sprite.animation_finished
	cursor_transformed.emit()
	_cursor_sprite.hide()
	_is_cursor_hidden = true


func get_global_pos() -> Vector2:
	return _click_area.global_position


func freeze() -> void:
	_is_cursor_hidden = true


func get_follow_node() -> Node2D:
	return GameManager.player as Node2D if _is_cursor_hidden else _click_area as Node2D


func set_cursor_type(_type: int) -> void:
	pass


func _warp_cursor(pos: Vector2) -> void:
	Input.warp_mouse(Vector2(
				pos.x * (get_window().size.x / float(Config.GAME_WIDTH)),
				pos.y * (get_window().size.y / float(Config.GAME_HEIGHT))
		))


func _set_cursor_sprite(img: CompressedTexture2D) -> void:
	Input.set_custom_mouse_cursor(img)
