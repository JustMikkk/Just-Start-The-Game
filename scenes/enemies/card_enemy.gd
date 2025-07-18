extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@export var _damage: int = 1


var _dir: int = 1

@onready var _ray_cast_2d: RayCast2D = $AnimatedSprite2D/RayCast2D
@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		_animated_sprite_2d.speed_scale = 0
		velocity += get_gravity() * delta
	else:
		_animated_sprite_2d.speed_scale = 1
	
	if not _ray_cast_2d.is_colliding() and is_on_floor():
		_dir *= -1
		_animated_sprite_2d.scale = Vector2(_dir, 1)
		
	velocity.x = SPEED * _dir

	move_and_slide()


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(_damage, 1 if body.global_position.x > global_position.x else -1)


func _on_jump_timer_timeout() -> void:
	velocity.y = JUMP_VELOCITY
