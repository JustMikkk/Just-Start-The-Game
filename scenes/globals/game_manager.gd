extends Node2D


const CURSOR = preload("res://assets/graphics/player/cursor.png")



var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	Input.set_custom_mouse_cursor(CURSOR)
