extends Node2D

var player: Player
var current_desktop: Desktop
var game: Game
var _desktops_manager: DesktopsManager

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	current_desktop = get_tree().get_first_node_in_group("Desktop")
	game = get_tree().get_first_node_in_group("Game")
	_desktops_manager = get_tree().get_first_node_in_group("DesktopsManager")


func go_to_desktop(index: int, with_app: bool) -> void:
	_desktops_manager.go_to_desktop(index, with_app)
