class_name Desktop
extends Node2D

@export var id_name: String
@export var _cutscene_name: String

var _bindows: Array[Bindow]

@onready var bg: Sprite2D = $BG
@onready var _taskbar: Taskbar = $Taskbar
@onready var _spawn_point: Marker2D = $SpawnPoint


func _ready() -> void:
	for node in $Apps.get_children():
		if node is App:
			node.app_opened_signal.connect(_on_app_open)
			node.app_exitd_signal.connect(_on_app_exit)
	
	for bindow in $Bindows.get_children():
		if bindow is Bindow:
			_bindows.append(bindow)


func _on_app_open(app: App) -> void:
	_taskbar.create_app(app)
	
	if app.bindow.z_index == 18: return
	
	for b in _bindows:
		b.z_index -= 1
	
	app.bindow.z_index = 18


func _on_app_exit(app: App) -> void:
	_taskbar.remove_app(app)


func reset() -> void:
	GameManager.player.global_position = _spawn_point.global_position
