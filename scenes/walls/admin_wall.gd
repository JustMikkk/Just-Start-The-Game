extends Area2D


func _ready() -> void:
	if GameManager.has_player_admin:
		queue_free()
	
	GameManager.adminwall_equipped.connect(func():
		queue_free()
	)


func _on_body_entered(body: Node2D) -> void:
	if not GameManager.has_player_admin:
		GameManager.player.take_damage(999, Vector2.ZERO)
