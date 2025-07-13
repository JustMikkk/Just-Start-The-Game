class_name App
extends Area2D


@export var is_fullcreen: bool
@export var bindow: Bindow
@export var bindow_pos: Vector2

var is_open: bool = false
var is_minimised: bool = false

@onready var _double_click_timer: Timer = $DoubleClickTimer



func _start_bindow() -> void:
	pass


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_pressed():
		if not _double_click_timer.time_left:
			_double_click_timer.start()
		else:
			print("jajo") 
