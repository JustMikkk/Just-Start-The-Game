class_name TaskbarApp
extends Area2D

var app: App
var _taskbar: Taskbar

var _tween_scale: Tween
var _tween_indicator: Tween
var _tween_location: Tween

@onready var _icon: Sprite2D = $Icon
@onready var _active_indicator: Sprite2D = $ActiveIndicator


func _ready() -> void:
	_icon.scale = Vector2.ZERO


func setup(_app: App, taskbar: Taskbar) -> void:
	app = _app
	_taskbar = taskbar
	
	await ready
	
	_icon.texture = self.app.taskbar_icon
	_tween_scale = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	_tween_scale.tween_property(_icon, "scale", Vector2.ONE, 0.3)
	_tween_scale.tween_property(_icon, "rotation_degrees", 360, 0.3)


func move_to_pos(pos: Vector2) -> void:
	if _tween_location:
		_tween_location.kill()
	
	_tween_location = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	_tween_location.tween_property(self, "position", pos, 0.4)



func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_pressed():
		if _tween_indicator:
			_tween_indicator.kill()
		
		_tween_indicator = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
		_tween_indicator.tween_property(_active_indicator, "scale:x", 1, 0.4)
		_tween_indicator.tween_property(_active_indicator, "scale:y", 1, 0.2)
