extends Node2D


#const ROTATION_SPEED := 90

@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#
#func _process(delta: float) -> void:
	#_animated_sprite_2d.rotation_degrees += delta * ROTATION_SPEED
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	Input.warp_mouse(GameManager.player.global_position)
	GameManager.player.set_enabled(false)
	CursorManager.show_cursor()
	
