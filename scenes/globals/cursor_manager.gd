extends Node2D

signal cursor_transformed


const CURSOR = preload("res://assets/graphics/player/cursor/cursor.png")
const CURSOR_CURIOUS = preload("res://assets/graphics/player/cursor/cursor_curious.png")

const CURSORS = [
		preload("res://assets/graphics/player/cursor/the_cursed_cursor_0001.png"),
		preload("res://assets/graphics/player/cursor/the_cursed_cursor_0002.png"),
		preload("res://assets/graphics/player/cursor/the_cursed_cursor_0003.png"),
		preload("res://assets/graphics/player/cursor/the_cursed_cursor_0004.png"),
		preload("res://assets/graphics/player/cursor/the_cursed_cursor_0005.png"),
		preload("res://assets/graphics/player/cursor/the_cursed_cursor_0006.png"),
		preload("res://assets/graphics/player/cursor/the_cursed_cursor_0007.png"),
		preload("res://assets/graphics/player/cursor/the_cursed_cursor_0008.png"),
		preload("res://assets/graphics/player/cursor/the_cursed_cursor_0009.png"),
		preload("res://assets/graphics/player/cursor/the_cursed_cursor_0010.png"),
	]

var _cursor_index: int = 0
var _change_time: float = 1 / 24.0
var _timer: float = 0.0

var _is_cursor_hidden: bool = false

@onready var _cursor_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_cursor_type(CursorType.DEFAULT)


func _process(delta: float) -> void:
	if _is_cursor_hidden: return
	
	scale.x = 1 if GameManager.player.is_looking_left() else -1
	global_position = Vector2i(get_global_mouse_position())
	
	#
	#_timer += delta
	#
	#if _timer >= _change_time:
		#_timer = 0
		#_set_cursor_sprite(CURSORS[_cursor_index])
		#
		#_cursor_index = (_cursor_index + 1) % CURSORS.size()


func is_cursor_hidden() -> bool:
	return _is_cursor_hidden


func show_warp_cursor(pos: Vector2) -> void:
	Input.warp_mouse(Vector2(
			pos.x * (get_window().size.x / float(Config.GAME_WIDTH)),
			pos.y * (get_window().size.y / float(Config.GAME_HEIGHT))
	))
	_is_cursor_hidden = false
	show_cursor() 


func show_cursor() -> void:
	_cursor_sprite.play("default")
	_cursor_sprite.show()
	_cursor_sprite.play("transform_into")
	await _cursor_sprite.animation_finished
	cursor_transformed.emit()
	_cursor_sprite.play("default")
	


func hide_cursor() -> void:
	_cursor_sprite.play("transform_from")
	await _cursor_sprite.animation_finished
	cursor_transformed.emit()
	_cursor_sprite.hide()
	_is_cursor_hidden = true
	


func set_cursor_type(type: int) -> void:
	return
	if _is_cursor_hidden: return
	
	var img: CompressedTexture2D
	
	match type:
		CursorType.DEFAULT:
			img = CURSOR
		CursorType.CURIOUS:
			img = CURSOR_CURIOUS
	
	_set_cursor_sprite(img)


func _set_cursor_sprite(img: CompressedTexture2D) -> void:
	Input.set_custom_mouse_cursor(img)
