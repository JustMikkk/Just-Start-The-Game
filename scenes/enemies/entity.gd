class_name Entity
extends CharacterBody2D

signal entity_died
signal damage_taken

@export var _health: int = 3
@export var _damage: int = 1


func _die() -> void:
	entity_died.emit()


func take_damage(amount: int, direction: Vector2) -> void:
	_health -= amount
	damage_taken.emit()
	
	if _health <= 0:
		_die()
