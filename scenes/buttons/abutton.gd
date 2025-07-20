class_name AButton
extends Area2D


signal mouse_click
signal mouse_enter
signal mouse_exit


@export var is_enabled: bool = true

var _click_area: ClickArea


#func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#if not is_enabled or CursorManager.is_cursor_hidden(): return
	#
	#if event is InputEventMouseButton \
			#and event.button_index == MOUSE_BUTTON_LEFT \
			#and event.is_pressed():
		#
		#mouse_click.emit()


func _on_mouse_entered() -> void:
	if not is_enabled or CursorManager.is_cursor_hidden(): return
	
	mouse_enter.emit()


func _on_mouse_exited() -> void:
	if not is_enabled or CursorManager.is_cursor_hidden(): return
	
	mouse_exit.emit()


func _on_area_entered(area: Area2D) -> void:
	if area is not ClickArea: return
	#if not is_enabled or not CursorManager.is_cursor_hidden(): return
	
	mouse_enter.emit()
	
	_click_area = area
	if not _click_area.click_area_click.is_connected(_on_click_area_click):
		_click_area.click_area_click.connect(_on_click_area_click)
	

func _on_area_exited(area: Area2D) -> void:
	if area is not ClickArea: return
	#if not is_enabled or not CursorManager.is_cursor_hidden(): return
	
	mouse_exit.emit()
	
	if _click_area and _click_area.click_area_click.is_connected(_on_click_area_click):
		_click_area.click_area_click.disconnect(_on_click_area_click)
	_click_area = null


func _on_tree_exiting() -> void:
	if _click_area != null:
		_click_area.click_area_click.disconnect(_on_click_area_click)


func _on_click_area_click() -> void:
	#if not is_enabled or not CursorManager.is_cursor_hidden(): return
	if not _click_area: return
	
	mouse_click.emit()
