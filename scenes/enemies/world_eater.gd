class_name WorldEater
extends Node2D


const WORLD_EATING_SQUARE = preload("res://scenes/enemies/world_eating_square.tscn")


var _current_y: int = -16
var _taken_positions: Array[Vector2]

var _is_purple: bool = false

var _tile_size := Vector2(32, 32)

@onready var _timer: Timer = $Timer
@onready var _current_pos := Vector2(_tile_size.x / 2, -_tile_size.y / 2)
@onready var world_eater: Node2D = $"."


func start_eating(initial_delay: float) -> void:
	await get_tree().create_timer(initial_delay).timeout
	_timer.start()


func _on_timer_timeout() -> void:
	var node: Node2D = WORLD_EATING_SQUARE.instantiate()
	
	var new_pos = Vector2(16, _current_y)
	while new_pos in _taken_positions:
		new_pos = Vector2(
			randi_range(0, 29) * 32 + 16,
			_current_y
		)
	
	node.position = new_pos
	node.modulate = Color.BLACK if int(new_pos.x - 16) % 32 == 0 else Color.MAGENTA
	
	_taken_positions.append(new_pos)
	
	if _taken_positions.size() % 30 == 0:
		_current_y -= 32
	
	#if GameManager.get_player_global_pos().y > Config.GAME_HEIGHT + (_current_pos.y + _tile_size.y / 2) - 20: # 20 for the player feet ofset
		#GameManager.player.take_damage(999, Vector2.ZERO)
	#
	#node.position = _current_pos
	#node.modulate = Color.BLACK if _is_purple else Color.MAGENTA
	#
	#if _current_pos.x == 960 - _tile_size.x / 2:
		#_current_pos = Vector2(_tile_size.x / 2, _current_pos.y - _tile_size.y)
	#else:
		#_current_pos.x += _tile_size.x
		#_is_purple = not _is_purple
	
	add_child(node)
	
	var new_scale_x: int = randi_range(25, 39)
	get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).tween_property(node, "scale", Vector2(new_scale_x, new_scale_x), 0.7)
