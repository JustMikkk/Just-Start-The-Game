extends Node2D

signal firewall_equipped
signal adminwall_equipped

var can_player_transform: bool = false

var has_player_scissors: bool = false
var has_player_admin: bool = false
var has_player_firewall: bool = false

var is_world_eater_eating: bool = false

var player: Player
var current_desktop: Desktop:
	get():
		return desktops_manager._current_desktop
var game: Game
var desktops_manager: DesktopsManager

var _cutscenes_played: Dictionary[String, bool] = {
	"desktop_1": false,
	"desktop_2": false,
	"desktop_3": false,
	"desktop_4": false,
	"desktop_5": false,
}



func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	game = get_tree().get_first_node_in_group("Game")
	desktops_manager = get_tree().get_first_node_in_group("DesktopsManager")


func get_player_global_pos() -> Vector2:
	return player.global_position if player.is_enabled() else CursorManager.get_global_pos()


func go_to_desktop(index: int, with_app: bool) -> void:
	desktops_manager.go_to_desktop(index, with_app)


func set_cutscene_played(key: String) -> void:
	_cutscenes_played[key] = true


func was_cutscene_played(key: String) -> bool:
	return _cutscenes_played[key]


func reset() -> void:
	game.transition_player.play_death_transition()
	await game.transition_player.ready_for_change
	player.reset()
	desktops_manager.reload_desktop()
	current_desktop.reset()


func add_power_up(id: String, global_pos: Vector2, texture: Texture) -> void:
	var destination: Vector2
	
	match id:
		"scissors":
			has_player_scissors = true
			destination = current_desktop.taskbar.scissors.global_position
		"admin":
			has_player_admin = true
			destination = current_desktop.taskbar.admin.global_position
			adminwall_equipped.emit()
		"firewall":
			has_player_firewall = true
			destination = current_desktop.taskbar.fire_wall.global_position
			firewall_equipped.emit()
	
	game.transition_player.play_power_up_transition(global_pos, texture, destination)
	


func has_player_power_up(id: String) -> bool:
	match id:
		"scissors":
			return has_player_scissors
		"admin":
			return has_player_admin
		"firewall":
			return has_player_firewall
	return false
