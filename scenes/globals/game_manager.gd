extends Node2D

var can_player_transform: bool = false

var player: Player
var current_desktop: Desktop
var game: Game

var _cutscenes_played: Dictionary[String, bool] = {
	"desktop_1": false,
	"desktop_2": false,
	"desktop_3": false,
	"desktop_4": false,
	"desktop_5": false,
}

var desktops_manager: DesktopsManager


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	game = get_tree().get_first_node_in_group("Game")
	desktops_manager = get_tree().get_first_node_in_group("DesktopsManager")


func go_to_desktop(index: int, with_app: bool) -> void:
	desktops_manager.go_to_desktop(index, with_app)


func set_cutscene_played(key: String) -> void:
	_cutscenes_played[key] = true


func was_cutscene_played(key: String) -> bool:
	return _cutscenes_played[key]


func reset() -> void:
	game.transition_player.play_death_transition()
	await game.transition_player.ready_for_change
	 
	current_desktop.reset()
