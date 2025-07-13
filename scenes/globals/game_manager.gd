extends Node2D


const CURSOR = preload("res://assets/graphics/player/cursor.png")

var player: Player
var current_desktop: Desktop

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	current_desktop = get_tree().get_first_node_in_group("Desktop")
	Input.set_custom_mouse_cursor(CURSOR)
