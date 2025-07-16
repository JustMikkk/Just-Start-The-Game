class_name DesktopHolder
extends Node2D

@export var _desktop: Node2D


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	print("jajsd")
	_desktop.show()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("jajsdasd")
	_desktop.hide()
