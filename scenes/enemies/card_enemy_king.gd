extends Entity

const CARD_ENEMY = preload("res://scenes/enemies/card_enemy.tscn")

@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		_animated_sprite_2d.speed_scale = 0
		velocity += get_gravity() * delta
	else:
		_animated_sprite_2d.speed_scale = 1
	
	move_and_slide()


func _on_throw_timer_timeout() -> void:
	var node: CardEnemy = CARD_ENEMY.instantiate()
	node.dir = -1
	node.velocity = Vector2(-10, -10)
	node._health = 1
	get_parent().add_child(node)
	node.position = position - Vector2(0, 50)
	node._animated_sprite_2d.scale.x = -1
