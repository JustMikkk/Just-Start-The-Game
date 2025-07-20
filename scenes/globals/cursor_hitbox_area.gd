extends Entity

@onready var _animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"

func _ready() -> void:
	_health = GameManager.player.health


func take_damage(amount: int, dir: Vector2) -> void:
	if CursorManager.is_cursor_hidden(): return
	GameManager.player.take_damage(amount, dir)
	
	_animated_sprite_2d.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	_animated_sprite_2d.modulate = Color.WHITE
	
