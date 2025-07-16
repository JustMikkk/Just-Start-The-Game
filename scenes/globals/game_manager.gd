extends Node2D



var player: Player
var current_desktop: Desktop

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	current_desktop = get_tree().get_first_node_in_group("Desktop")


func _physics_process(_delta: float) -> void:
	_debug_commands()


func _debug_commands():
	pass
	#if Input.is_action_just_released("ui_up"):
		#print("jaja")
		#player.set_enabled(true if player.state == 5 else false, Vector2(480, 320))
