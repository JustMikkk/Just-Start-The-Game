class_name Player
extends CharacterBody2D


enum State {
	IDLE,
	RUN,
	JUMP,
	AIR,
	DEAD,
	DISABLED,
	CROUCH,
	TRANSFORMING,
}

@export var SPEED = 10400
@export var JUMP_VELOCITY = -32000
@export var START_GRAVITY = 1700
@export var COYOTE_TIME = 140 # in ms
@export var JUMP_BUFFER_TIME = 100 # in ms
@export var JUMP_CUT_MULTIPLIER = 0.4
@export var AIR_HANG_MULTIPLIER = 0.95
@export var AIR_HANG_THRESHOLD = 50
@export var Y_SMOOTHING = 0.8
@export var AIR_X_SMOOTHING = 0.10
@export var MAX_FALL_SPEED = 25000


var _prevVelocity := Vector2.ZERO
var _lastFloorMsec: float = 0
var _wasOnFloor := false
var _lastJumpQueueMsec: int
var _gravity = START_GRAVITY

var _fall_timer: float = 0.0
var _fall_splash_treshold: float = 1.2


@onready var state: State = State.DISABLED:
	set(val):
		state = val
		_update_click_are_pos()

@onready var _animated_sprite_2d: AnimatedSprite2D = $"AnimatedSprite2D"
@onready var _collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var _floor_ray_cast_2d: RayCast2D = $FloorRayCast2D
@onready var _crouch_timer: Timer = $CrouchTimer
@onready var _collision_disabled_timer: Timer = $CollisionDisabledTimer
@onready var _click_area: ClickArea = $AnimatedSprite2D/ClickArea


func _physics_process(delta):
	if state == State.DISABLED: return
	
	var direction = Input.get_axis("left", "right")
	
	if is_on_floor():
		_lastFloorMsec = Time.get_ticks_msec()
		
		
	elif state != State.JUMP and state != State.AIR and state != State.DEAD:
		state = State.AIR
	
	match state:
		State.JUMP:
			_animated_sprite_2d.animation = "jump"
			
			velocity.y = JUMP_VELOCITY * delta
			state = State.AIR
			_fall_timer = 0
			
		State.AIR:
			_fall_timer += delta
			_animated_sprite_2d.animation = "jump"
			
			
			if is_on_floor():
				state = State.IDLE if _fall_timer < _fall_splash_treshold else State.CROUCH
			
			if Input.is_action_just_released("jump"):
				velocity.y *= JUMP_CUT_MULTIPLIER
			
			_run(direction, delta)
			velocity.x = lerp(_prevVelocity.x, velocity.x, AIR_X_SMOOTHING)
			
			if Input.is_action_just_pressed("jump"):
				if Time.get_ticks_msec() - _lastFloorMsec < COYOTE_TIME:
					state = State.JUMP
				else:
					_lastJumpQueueMsec = Time.get_ticks_msec()
					
			velocity.y += _gravity * delta
			
			if abs(velocity.y) < AIR_HANG_THRESHOLD:
				_gravity *= AIR_HANG_MULTIPLIER
			else:
				_gravity = START_GRAVITY
			
		
		State.IDLE:
			_animated_sprite_2d.animation = "idle"
			
			if Time.get_ticks_msec() - _lastJumpQueueMsec < JUMP_BUFFER_TIME or Input.is_action_just_pressed("jump"): # jump buffer
				state = State.JUMP
				
			else:
				velocity.x = 0
				
				if direction != 0:
					state = State.RUN
			
				elif is_on_floor() and Input.is_action_just_pressed("down"):
					_crouch_timer.start()
					state = State.CROUCH
				
		
		State.RUN:
			_animated_sprite_2d.animation = "run"
			
			_run(direction, delta)
			
			if direction == 0:
				state = State.IDLE
			elif Input.is_action_just_pressed("jump"): 
				state = State.JUMP
		
		State.CROUCH:
			
			if not Input.is_action_pressed("down"):
				if _animated_sprite_2d.animation != "crouch_reverse":
					_animated_sprite_2d.play("crouch_reverse")
				
				_animated_sprite_2d.animation = "crouch_reverse"
				
				if not _animated_sprite_2d.is_playing():
					state = State.IDLE
					_animated_sprite_2d.play("idle")
			 
			elif _crouch_timer.time_left:
				if _animated_sprite_2d.animation != "crouch":
						_animated_sprite_2d.frame = 0
				_animated_sprite_2d.animation = "crouch"
			else:
				_animated_sprite_2d.animation = "crouch_loop"
				
				if not _floor_ray_cast_2d.is_colliding() and global_position.y < 592:
					_collision_disabled_timer.start()
					state = State.AIR
					_animated_sprite_2d.play("jump")
					call_deferred("_disable_collisions")
		
		State.DEAD:
			pass
	
	velocity.y = lerp(_prevVelocity.y, velocity.y, Y_SMOOTHING)
	velocity.y = min(velocity.y, MAX_FALL_SPEED * delta)
	
	_wasOnFloor = is_on_floor()
	_prevVelocity = velocity
	
	move_and_slide()


func set_enabled(enabled: bool, pos: Vector2) -> void:
	if enabled == (state != State.DISABLED): return
	if not GameManager.can_player_transform: return
	velocity = Vector2.ZERO
	
	if enabled:
		_click_area.is_enabled = true
		_animated_sprite_2d.flip_h = true
		CursorManager.hide_cursor()
		await CursorManager.cursor_transformed
		state = State.IDLE
		global_position = pos
		_animated_sprite_2d.show()
		call_deferred("_enable_collisions")
	
	else:
		_animated_sprite_2d.flip_h = true
		state = State.DISABLED
		_animated_sprite_2d.hide()
		call_deferred("_disable_collisions")
		global_position = Vector2.ZERO
		CursorManager.show_warp_cursor(pos)
		#await CursorManager.cursor_transformed


func is_enabled() -> bool:
	return state != State.DISABLED


func die() -> void:
	state = State.DEAD
	velocity.x = 0
	velocity.y = 0
	_animated_sprite_2d.stop()
	_animated_sprite_2d.play("dead")


func freeze() -> void:
	state = State.DISABLED


func unfreeze() -> void:
	state = State.IDLE
	_click_area.is_enabled = true


func _input(event) -> void:
	if event is InputEventMouseMotion:
		if event.relative.x > 0:
			global_position.x += 50 * get_process_delta_time()
		if event.relative.x < 0:
			global_position.x -= 50 * get_process_delta_time()
		if event.relative.y > 0:
			global_position.y += 50 * get_process_delta_time()
		if event.relative.y < 0:
			global_position.y -= 50 * get_process_delta_time()



func _run(direction, delta) -> void:
	velocity.x = SPEED * direction * delta
	if not direction == 0:
		_animated_sprite_2d.scale.x = -1 if direction >= 0 else 1


func _update_click_are_pos() -> void:
	match state:
		State.IDLE:
			_click_area.position = Vector2(5, -22)
		State.JUMP:
			_click_area.position = Vector2(-16, -20)
		State.AIR:
			_click_area.position = Vector2(-16, -20)
		State.CROUCH:
			_click_area.position = Vector2(8, 0)
		State.RUN:
			_click_area.position = Vector2(6, -21)
		_:
			_click_area.is_enabled = false
	


func _enable_collisions() -> void:
	_collision_shape_2d.disabled = false


func _disable_collisions() -> void:
	_collision_shape_2d.disabled = true


func _on_collision_disabled_timer_timeout() -> void:
	call_deferred("_enable_collisions")
