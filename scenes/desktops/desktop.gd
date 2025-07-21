class_name Desktop
extends Node2D

@export var id_name: String
@export var _cutscene_name: String
@export var _starting_as_cursor: bool = false
@export var _world_eater_initial_delay: float = 3

var _bindows: Array[Bindow]

@onready var bg: Sprite2D = $BG
@onready var world_eater: WorldEater = $WorldEater

@onready var taskbar: Taskbar = $Taskbar
@onready var _spawn_point: Marker2D = $SpawnPoint


func _ready() -> void:
	if GameManager.is_world_eater_eating:
		world_eater.start_eating(_world_eater_initial_delay)
	
	for bindow in $Bindows.get_children():
		if bindow is Bindow:
			_bindows.append(bindow)


func connect_app(app: App) -> void:
	app.app_opened_signal.connect(_on_app_open)
	app.app_exited_signal.connect(_on_app_exit)


func _on_app_open(app: App) -> void:
	taskbar.create_app(app)
	
	if app.bindow.z_index == 18: return
	
	for b in _bindows:
		b.z_index -= 1
	
	app.bindow.z_index = 18


func _on_app_exit(app: App) -> void:
	taskbar.remove_app(app)


func reset() -> void:
	GameManager.player.set_enabled(!_starting_as_cursor, _spawn_point.global_position)
	
	scale = Vector2.ONE
	GameManager.player.global_position = _spawn_point.global_position
