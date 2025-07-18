class_name DesktopsManager
extends Node2D


const _desktop_prefabs: Dictionary[String, PackedScene] = {
	"desktop_1": preload("res://scenes/desktops/desktop_1.tscn"),
	"desktop_2": preload("res://scenes/desktops/desktop_2.tscn"),
	"desktop_3": preload("res://scenes/desktops/desktop_3.tscn"),
	"desktop_4": preload("res://scenes/desktops/desktop_4.tscn"),
	"desktop_5": preload("res://scenes/desktops/desktop_5.tscn"),
	"desktop_6": preload("res://scenes/desktops/desktop_6.tscn"),
}

const _map: Array[Array] = [
	["", 			"", 			"", 			""],
	["", 			"desktop_3", 	"desktop_6", 	""],
	["desktop_1", 	"desktop_2", 	"desktop_5", 	""],
	["", 			"desktop_4", 	"", 			""],
	["", 			"", 			"", 			""],
]

var current_desktop_id: String = "desktop_1"

var desktop_index: int = 0

var _is_moving: bool = false

var _tween_alpha: Tween
var _tween_player_scale: Tween
var _tween_scale: Tween

var _tween_transition: Tween

var _reset_timer: float = 0
var _reset_hold_threshold: float = 1.5

@onready var _blurred_bg_back: Sprite2D = $BlurredBG_Back
@onready var _blurred_bg_front: Sprite2D = $BlurredBG_Front
@onready var _desktops_holder: Node2D = $DesktopsHolder

@onready var _current_desktop_cords: Vector2i = _get_desktop_cords(current_desktop_id)
@onready var _current_desktop: Desktop = $"DesktopsHolder/Desktop 1"


func _ready() -> void:
	GameManager.current_desktop = _current_desktop


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		_move_to_desktop("desktop_1")
	elif Input.is_action_just_pressed("debug2"):
		_move_to_desktop("desktop_2")
	
	
	if not GameManager.can_player_transform: return # so the player doesnt reset before the initial cutscene
	if _is_moving: return
	
	if Input.is_action_just_pressed("reset"):
		if _tween_scale:
			_tween_scale.kill()
		
		_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		_tween_scale.tween_property(_current_desktop, "scale", Vector2(0.3, 0.3), _reset_hold_threshold)
		_tween_scale.tween_callback(func():
			GameManager.reset()
			await GameManager.game.transition_player.ready_for_change
			_current_desktop.scale = Vector2.ONE
		)
	
	elif Input.is_action_just_released("reset"):
		if _tween_scale:
			_tween_scale.kill()
		
		_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		_tween_scale.tween_property(_current_desktop, "scale", Vector2.ONE,  0.7)



func move_in_direction(dir: Vector2i, with_scaling: bool) -> void:
	var new_id: String = _get_desktop_id_at_cords(_current_desktop_cords + dir)
	if new_id != "":
		if with_scaling:
			_move_to_desktop(new_id)
		else:
			_switch_desktop_normal(new_id)


func can_move_in_direction(id: String, dir: Vector2i) -> bool:
	return _get_desktop_id_at_cords(_get_desktop_cords(id) + dir) != ""


func _switch_desktop_normal(new_desktop_id: String) -> void:
	if _is_moving: return
	if current_desktop_id == new_desktop_id: return
	
	_is_moving = true
	# new desktop setup
	var dir: Vector2i = _get_desktop_cords(new_desktop_id) - _current_desktop_cords # (1, 1) - bottom-right
	var initial_pos := Vector2(
			dir.x * Config.GAME_WIDTH,
			dir.y * Config.GAME_HEIGHT
	)
	var new_desktop: Desktop = _desktop_prefabs.get(new_desktop_id).instantiate()
	new_desktop.position = initial_pos
	
	(func():
		_desktops_holder.add_child(new_desktop)
	).call_deferred()
	
	# player handling
	if GameManager.player.is_enabled():
		GameManager.player.freeze()
		_tween_player_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		_tween_player_scale.tween_property(GameManager.player, "global_position", Vector2(
				480 + 465 * -dir.x if dir.x else GameManager.player.global_position.x,
				320 + 305 * -dir.y if dir.y else GameManager.player.global_position.y
		), 1)
		_tween_player_scale.tween_callback(
			GameManager.player.unfreeze
		)
	
	_tween_transition = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	_tween_transition.tween_property(new_desktop, "position", Vector2.ZERO, 1)
	_tween_transition.tween_property(_current_desktop, "position", initial_pos * -1, 1)
	
	await _tween_transition.finished
	
	_current_desktop.queue_free()
	_current_desktop = new_desktop
	
	current_desktop_id = new_desktop_id
	_current_desktop_cords = _get_desktop_cords(current_desktop_id)
	
	_is_moving = false


func _move_to_desktop(new_desktop_id: String) -> void:
	if _is_moving: return
	if current_desktop_id == new_desktop_id: return
	
	_is_moving = true
	# new desktop setup
	var dir: Vector2i = _get_desktop_cords(new_desktop_id) - _current_desktop_cords # (1, 1) - bottom-right
	var initial_pos := Vector2(
			dir.x * Config.GAME_WIDTH,
			dir.y * Config.GAME_HEIGHT
	)
	var new_desktop: Desktop = _desktop_prefabs.get(new_desktop_id).instantiate()
	new_desktop.position = initial_pos
	
	_desktops_holder.add_child(new_desktop)
	
	# prep for transition
	_blurred_bg_front.modulate.a = 1
	_blurred_bg_back.modulate.a = 0
	
	_blurred_bg_front.texture = _current_desktop.bg.texture
	_blurred_bg_back.texture = new_desktop.bg.texture
	
	# bg change
	_tween_alpha = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	_tween_alpha.tween_property(_blurred_bg_front, "modulate:a", 0, 2.4)
	_tween_alpha.tween_property(_blurred_bg_back, "modulate:a", 1, 2.4)
	
	# player handling
	if GameManager.player.is_enabled():
		GameManager.player.freeze()
		_tween_player_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		_tween_player_scale.tween_property(GameManager.game.player_holder, "scale", Vector2(0.75, 0.75), 0.7)
		_tween_player_scale.tween_interval(1)
		_tween_player_scale.tween_property(GameManager.game.player_holder, "scale", Vector2.ONE, 0.7)
		_tween_player_scale.tween_callback(
			GameManager.player.unfreeze
		)
	
	_tween_desktop_to_pos(_current_desktop, initial_pos * -1)
	_tween_desktop_to_pos(new_desktop, Vector2.ZERO)
	
	#_tween_transition = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	#_tween_transition.tween_property(new_desktop, "position", Vector2.ZERO, 1)
	#_tween_transition.tween_property(_current_desktop, "position", initial_pos * -1, 1)
	
	await _tween_alpha.finished
	
	#_current_desktop.queue_free()
	_current_desktop = new_desktop
	
	current_desktop_id = new_desktop_id
	_current_desktop_cords = _get_desktop_cords(current_desktop_id)
	
	_is_moving = false


func _tween_desktop_to_pos(desktop: Node2D, pos: Vector2) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(desktop, "scale", Vector2(0.75, 0.75), 0.7)
	
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(desktop, "position", pos + Vector2(480, 0), 1)
	
	#tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	#tween.tween_property(desktop, "scale", Vector2.ONE, 0.7)


func _get_desktop_id_at_cords(cords: Vector2i) -> String:
	if cords.y >= _map.size() or cords.x >= _map[0].size(): return ""
	return _map[cords.y][cords.x]


func _get_desktop_cords(name: String) -> Vector2i:
	for y in range(_map.size()):
		for x in range(_map[y].size()):
			if _map[y][x] == name:
				return Vector2i(x, y)
	
	return Vector2i(-1, -1)
