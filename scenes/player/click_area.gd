class_name ClickArea
extends Area2D


signal click_area_click

var is_enabled: bool = false

func _physics_process(delta: float) -> void:
	if not is_enabled: return
	
	if Input.is_action_just_pressed("click"):
		click_area_click.emit()
