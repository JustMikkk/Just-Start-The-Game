extends Node


const GAME_WIDTH: int = 960
const GAME_HEIGHT: int = 640
const DOUBLE_CLICK_TIMING: float = 0.9

const CURSOR = preload("res://assets/graphics/player/cursor/cursor.png")
const CURSOR_CURIOUS = preload("res://assets/graphics/player/cursor/cursor_curious.png")

const APP_CLOSE_TIME: float = 0.3

func _ready() -> void:
	
	set_cursor_type(CursorType.DEFAULT)


func set_cursor_type(type: int) -> void:
	var img: CompressedTexture2D
	
	match type:
		CursorType.DEFAULT:
			img = CURSOR
		CursorType.CURIOUS:
			img = CURSOR_CURIOUS
	
	Input.set_custom_mouse_cursor(img)
