class_name Desktop
extends Node2D

@export var id_name: String
@export var _cutscene_name: String

var _apps: Array[App]

@onready var bg: Sprite2D = $BG
@onready var _taskbar: Taskbar = $Taskbar
@onready var _spawn_point: Marker2D = $SpawnPoint


func _ready() -> void:
	for node in $Apps.get_children():
		if node is App:
			_apps.append(node)
			node.app_opened_signal.connect(_on_app_open)
			node.app_exitd_signal.connect(_on_app_exit)


func _on_app_open(app: App) -> void:
	_taskbar.create_app(app)
	
	for a in _apps:
		a.z_index -= 1
	
	app.z_index = 8

func _on_app_exit(app: App) -> void:
	_taskbar.remove_app(app)


func reset() -> void:
	GameManager.player.global_position = _spawn_point.global_position
