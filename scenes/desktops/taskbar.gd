class_name Taskbar
extends Node2D

const TASKBAR_APP = preload("res://scenes/apps/taskbar_app.tscn")

var _apps: Array[App] = []
var _taskbar_apps: Array[TaskbarApp] = []

var _counter: int = 0

@onready var _taskbar_app_holder: Node2D = $TaskbarAppHolder


func create_app(app: App) -> void:
	if app in _apps: return
	_apps.append(app)
	
	var taskbar_app: TaskbarApp = TASKBAR_APP.instantiate()
	taskbar_app.position = Vector2(
			88 + _counter * 48,
			24
	)
	taskbar_app.setup(app, self)
	
	_taskbar_apps.append(taskbar_app)
	_taskbar_app_holder.add_child(taskbar_app)
	
	_counter += 1


func remove_app(app: App) -> void:
	if app not in _apps: return
	await get_tree().create_timer(Config.APP_CLOSE_TIME).timeout
	
	_apps.erase(app)
	
	## removing the app
	for ta in _taskbar_apps:
		if ta.app == app:
			_taskbar_apps.erase(ta)
			_taskbar_app_holder.remove_child(ta)
			break
	
	## aligning other apps
	_counter = 0
	for ta in _taskbar_apps:
		ta.move_to_pos(Vector2(
				88 + _counter * 48,
				24
		))
		_counter += 1
