extends Node


const CURSOR = preload("res://assets/graphics/player/cursor/cursor.png")
const CURSOR_CURIOUS = preload("res://assets/graphics/player/cursor/cursor_curious.png")

var _is_cursor_hidden: bool = false


func _ready() -> void:
	set_cursor_type(CursorType.DEFAULT)


func is_cursor_hidden() -> bool:
	return _is_cursor_hidden


func show_cursor() -> void:
	_is_cursor_hidden = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func hide_cursor() -> void:
	_is_cursor_hidden = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func set_cursor_type(type: int) -> void:
	if _is_cursor_hidden: return
	
	var img: CompressedTexture2D
	
	match type:
		CursorType.DEFAULT:
			img = CURSOR
		CursorType.CURIOUS:
			img = CURSOR_CURIOUS
	
	Input.set_custom_mouse_cursor(img)
