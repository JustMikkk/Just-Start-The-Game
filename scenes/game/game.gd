class_name Game
extends Node2D


var _desktops: Array[Desktop]


func _ready() -> void:
	for node in get_tree().get_nodes_in_group("Desktop"):
		if node is Desktop:
			_desktops.append(node)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		_move(1)
	elif Input.is_action_just_pressed("debug2"):
		_move(-1)
		

func _move(dir: int) -> void:
	for desktop in _desktops:
		var tween: Tween = get_tree().create_tween()
		
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		tween.tween_property(desktop, "scale", Vector2(0.75, 0.75), 0.7)
		
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(desktop, "global_position", desktop.global_position + Vector2(960 * dir, 0), 1)
		
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		tween.tween_property(desktop, "scale", Vector2.ONE, 0.7)
	
