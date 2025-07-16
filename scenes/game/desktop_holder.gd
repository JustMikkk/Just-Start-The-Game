class_name DesktopHolder
extends Node2D

@export var desktop: Desktop


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	desktop.show()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	desktop.hide()
