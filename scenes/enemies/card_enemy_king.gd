extends Entity

const CARD_ENEMY = preload("res://scenes/enemies/card_enemy.tscn")
const CARD_ENEMY_FLYING = preload("res://scenes/enemies/card_enemy_flying.tscn")

@export var _exit_to_enable: Area2D

@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	_exit_to_enable.disable()
	damage_taken.connect(func():
		_animated_sprite_2d.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		_animated_sprite_2d.modulate = Color.WHITE
	)
	entity_died.connect(func():
		_exit_to_enable.enable()
		queue_free()
	)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		_animated_sprite_2d.speed_scale = 0
		velocity += get_gravity() * delta
	else:
		_animated_sprite_2d.speed_scale = 1
	
	move_and_slide()


func _on_throw_timer_timeout() -> void:
	var node
	var scale
	
	if randi_range(0, 1) == 1:
		node = CARD_ENEMY.instantiate()
		node.dir = -1
		scale = -1
	else:
		node = CARD_ENEMY_FLYING.instantiate()
		scale = 1
		
	node.velocity = Vector2(-10, -10)
	node._health = 1
	get_parent().add_child(node)
	node.position = position - Vector2(0, 50)
	node._animated_sprite_2d.scale.x = scale
