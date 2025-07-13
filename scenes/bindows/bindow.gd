class_name Bindow
extends Node2D

var width: float = 192
var height: float = 185
var padding: float = 10

var is_dragged: bool = false
var drag_offset: Vector2 = Vector2.ZERO

@onready var previous_pos: Vector2 = global_position

func _physics_process(_delta: float) -> void:
	if not is_dragged: return
	
	var goal_pos: Vector2 = get_global_mouse_position() + drag_offset
	
	var pos_x: int = floor(clamp(goal_pos.x, width / 2, Config.GAME_WIDTH - (width / 2)))
	var pos_y: int = floor(clamp(goal_pos.y, height /2, Config.GAME_HEIGHT - (height / 2)))
	
	global_position = Vector2(int(pos_x), int(pos_y))
	#global_position = Vector2(int(pos_x) - int(pos_x) % 16, int(pos_y) - int(pos_y) % 16)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				is_dragged = false
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				#GameManager.enable_player(get_global_mouse_position(), false)
				Input.warp_mouse(GameManager.player.global_position)
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_drag_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				drag_offset = global_position - get_global_mouse_position()
				is_dragged = true
