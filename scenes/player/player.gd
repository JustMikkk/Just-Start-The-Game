class_name Player
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var current_bindow: Bindow

var _is_left: bool = false
var _tween_turning: Tween

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if not self.visible: return 
	
	# Add the gravity.
	if not is_on_floor():
		#animated_sprite_2d.animation = "jump"
		velocity += get_gravity() * delta
	#else:
		#C

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if abs(velocity.x) > 100:
		_handle_turning(velocity.x < 0)
	
	
	
	move_and_slide()
	
	
	_handle_animation()


func _process(_delta: float) -> void:
	position = Vector2(int(position.x), int(position.y))


func set_enabled(val: bool) -> void:
	self.visible = val
	call_deferred("_disable_collision")


func _disable_collision() -> void:
	$CollisionShape2D.disabled = !self.visible


func _handle_turning(turn_left: bool) -> void:
	if (turn_left == _is_left): return
	
	if _tween_turning:
		_tween_turning.kill()
	
	_tween_turning = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_tween_turning.tween_property(animated_sprite_2d, "scale:x", -1 if turn_left else 1, 0.3)
	
	_is_left = turn_left


func _handle_animation() -> void:
	
	#animated_sprite_2d.speed_scale = abs(velocity.x / SPEED)
	
	if (velocity.x == 0):
		animated_sprite_2d.animation = "default"
	else:
		animated_sprite_2d.animation = "run"
