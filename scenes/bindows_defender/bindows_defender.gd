class_name BindowsDefender
extends Node2D

@onready var _collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var _collision_shape_2d_2: CollisionShape2D = $StaticBody2D/CollisionShape2D2
@onready var _collision_shape_2d_3: CollisionShape2D = $StaticBody2D/CollisionShape2D3


func enable_collisions(enable: bool):
	if enable:
		call_deferred("_enable_collisions")
	else:
		call_deferred("_disable_collisions")


func _disable_collisions() -> void:
	_collision_shape_2d.disabled = true 
	_collision_shape_2d_2.disabled = true 
	_collision_shape_2d_3.disabled = true


func _enable_collisions() -> void:
	_collision_shape_2d.disabled = false
	_collision_shape_2d_2.disabled = false 
	_collision_shape_2d_3.disabled = false
