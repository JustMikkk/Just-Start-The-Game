extends AButton


@export var _dir: Vector2i

@onready var _icon: Sprite2D = $Icon
@onready var _desktop: Desktop = $"../.."


func _ready() -> void:
	mouse_click.connect(_on_mouse_click)
	
	match _dir:
		Vector2i(0, -1):
			rotation_degrees = 180
		Vector2i(1, 0):
			rotation_degrees = -90
		Vector2i(-1, 0):
			rotation_degrees = 90
	
	if not GameManager.desktops_manager.can_move_in_direction(_desktop.id_name, _dir):
		hide()
		(func():
			$StaticBody2D/CollisionShape2D.disabled = true
			$StaticBody2D/CollisionShape2D2.disabled = true
		).call_deferred()


func _on_mouse_click() -> void:
	#if not CursorManager.is_cursor_hidden(): return
	GameManager.desktops_manager.move_in_direction(_dir, false)
