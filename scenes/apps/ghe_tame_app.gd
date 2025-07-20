extends App


# overrides so it doesnt show up in taskbar and transform
func _ready() -> void:
	mouse_click.connect(_on_mouse_click)
	mouse_enter.connect(_on_mouse_enter)
	mouse_exit.connect(_on_mouse_exit)


func _open_bindow() -> void:
	GameManager.can_player_transform = true
	GameManager.player.set_enabled(true, CursorManager.get_global_pos())
	GameManager.set_cutscene_played("desktop_1")
