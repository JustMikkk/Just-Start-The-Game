extends Area2D

@export var _power_up_id: String
@export var _texture: Texture

func _ready() -> void:
	if GameManager.has_player_power_up(_power_up_id):
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if not GameManager.player.is_enabled(): return
	
	GameManager.add_power_up(_power_up_id, global_position, _texture)
	queue_free()
	
