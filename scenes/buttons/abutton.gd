class_name AButton
extends Area2D


signal mouse_click
signal mouse_enter
signal mouse_exit

@export var is_enabled: bool = true


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not is_enabled or CursorManager.is_cursor_hidden(): return
	
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_pressed():
		
		mouse_click.emit()


func _on_mouse_entered() -> void:
	if not is_enabled or CursorManager.is_cursor_hidden(): return
	
	mouse_enter.emit()


func _on_mouse_exited() -> void:
	if not is_enabled or CursorManager.is_cursor_hidden(): return
	
	mouse_exit.emit()
