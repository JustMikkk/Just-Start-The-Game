extends Node2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Player: return
	
	GameManager.player.set_enabled(false, global_position)
	
