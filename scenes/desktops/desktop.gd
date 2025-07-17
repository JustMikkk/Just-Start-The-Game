class_name Desktop
extends Node2D

@onready var bg: Sprite2D = $BG
@onready var _taskbar: Taskbar = $Taskbar


func _ready() -> void:
	for node in $Apps.get_children():
		if node is App:
			node.app_opened_signal.connect(_on_app_open)
			node.app_closed_signal.connect(_on_app_close)


func _on_app_open(app: App) -> void:
	_taskbar.create_app(app)


func _on_app_close(app: App) -> void:
	_taskbar.remove_app(app)
