extends App


func _ready() -> void:
	super()
	
	app_opened_signal.connect(_on_app_opened)


func _on_app_opened(_app: App) -> void:
	GameManager.is_world_eater_eating = true
	GameManager.current_desktop.world_eater.start_eating(1)
