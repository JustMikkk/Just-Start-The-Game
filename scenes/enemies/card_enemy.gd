class_name CardEnemy
extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@export var _damage: int = 1
@export var _health: int = 1

var _dir: int = 1
var _hit_velocity_x: float
var _decelleration: float = 1000

var _is_hit: bool = false

@onready var _ray_cast_2d: RayCast2D = $AnimatedSprite2D/RayCast2D
@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	if _is_hit: 
		velocity.x = _hit_velocity_x * delta
		move_and_slide()
		return
	
	if not is_on_floor():
		_animated_sprite_2d.speed_scale = 0
		velocity += get_gravity() * delta
	else:
		_animated_sprite_2d.speed_scale = 1
	
	if not _ray_cast_2d.is_colliding() and is_on_floor():
		_dir *= -1
		_animated_sprite_2d.scale = Vector2(_dir, 1)
		
	velocity.x = move_toward(velocity.x, SPEED * _dir, _decelleration * delta)

	move_and_slide()


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(_damage, 1 if body.global_position.x > global_position.x else -1)


func _on_jump_timer_timeout() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY


func take_damage(amount: int, dir: Vector2) -> void:
	_hit_velocity_x = dir.x * 10000
	_is_hit = true
	_health -= amount
	_animated_sprite_2d.modulate = Color.RED
	
	velocity.y = dir.y * 40000 * get_process_delta_time()
	print(dir.x)
	
	if _health <= 0:
		queue_free()
	await get_tree().create_timer(0.1).timeout
	_is_hit = false
	_animated_sprite_2d.modulate = Color.WHITE
	
