class_name Desktop
extends Node2D


@onready var taskbar: Taskbar = $Taskbar


func _ready() -> void:
	for node in get_tree().get_nodes_in_group("App"):
		if node is App:
			node.app_opened_signal.connect(_on_app_open)
			node.app_closed_signal.connect(_on_app_close)


func _on_app_open(app: App) -> void:
	taskbar.create_app(app)


func _on_app_close(app: App) -> void:
	taskbar.remove_app(app)
