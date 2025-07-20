# the base is from TheCodingKid tutorials 

class_name Player
extends Entity

enum State {
	IDLE,
	RUN,
	JUMP,
	AIR,
	DEAD,
	DISABLED,
	CROUCH,
	TRANSFORMING,
	DAMAGED,
	POGO_JUMP,
	ATTACK,
	ATTACK_UP,
	ATTACK_DOWN,
	POGO_AIR
}

@export var _audio_clip: AudioStream

@export var SPEED = 10400
@export var JUMP_VELOCITY = -32000
@export var POGO_JUMP_VELOCITY = -16000
@export var START_GRAVITY = 1700
@export var COYOTE_TIME = 140 # in ms
@export var JUMP_BUFFER_TIME = 100 # in ms
@export var JUMP_CUT_MULTIPLIER = 0.4
@export var AIR_HANG_MULTIPLIER = 0.95
@export var AIR_HANG_THRESHOLD = 50
@export var Y_SMOOTHING = 0.8
@export var AIR_X_SMOOTHING = 0.10
@export var MAX_FALL_SPEED = 25000

var health:
	get():
		return _health

var _prevVelocity := Vector2.ZERO
var _lastFloorMsec: float = 0
var _wasOnFloor := false
var _lastJumpQueueMsec: int
var _gravity = START_GRAVITY
var _attack_direction: Vector2

var _fall_timer: float = 0.0
var _fall_splash_treshold: float = 1.2

var _tween_tint: Tween


@onready var state: State = State.DISABLED:
	set(val):
		state = val
		_update_click_are_pos()
		if state != State.DISABLED:
			_animated_sprite_2d.play()

@onready var _animated_sprite_2d: AnimatedSprite2D = $"AnimatedSprite2D"
@onready var _collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var _floor_ray_cast_2d: RayCast2D = $FloorRayCast2D
@onready var _crouch_timer: Timer = $CrouchTimer
@onready var _collision_disabled_timer: Timer = $CollisionDisabledTimer
@onready var _click_area: ClickArea = $AnimatedSprite2D/ClickArea

@onready var _slash: Area2D = $AnimatedSprite2D/Slash
@onready var _slash_sprite_2d: Sprite2D = $AnimatedSprite2D/Slash/Sprite2D
@onready var _slash_collision: CollisionShape2D = $AnimatedSprite2D/Slash/CollisionShape2D


func _physics_process(delta):
	#print("state:", state)
	#print("global pos", global_position)
	#print("velocity", velocity)
	if state == State.DISABLED: return
	
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if is_on_floor():
		_lastFloorMsec = Time.get_ticks_msec()
		
	elif state != State.JUMP and state != State.AIR and state != State.POGO_JUMP and state != State.DEAD and state != State.ATTACK and state != State.POGO_AIR:
		state = State.AIR
	
	match state:
		State.JUMP:
			_animated_sprite_2d.animation = "jump"
			
			velocity.y = JUMP_VELOCITY * delta
			state = State.AIR
			_fall_timer = 0
		
		State.POGO_JUMP:
			_animated_sprite_2d.animation = "pogo"
			
			velocity.y = JUMP_VELOCITY * delta
			state = State.POGO_AIR
			_fall_timer = 0
			
		State.POGO_AIR:
			_fall_timer += delta
			_animated_sprite_2d.animation = "pogo"
			
			if not _animated_sprite_2d.is_playing():
				state = State.AIR
			
			_run(direction, delta)
			velocity.x = lerp(_prevVelocity.x, velocity.x, AIR_X_SMOOTHING)
			
			velocity.y += _gravity * delta
			
			if abs(velocity.y) < AIR_HANG_THRESHOLD:
				_gravity *= AIR_HANG_MULTIPLIER
			else:
				_gravity = START_GRAVITY
		
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
				
				if direction.x != 0:
					state = State.RUN
			
				elif is_on_floor() and Input.is_action_just_pressed("down"):
					_crouch_timer.start()
					state = State.CROUCH
				
		
		State.RUN:
			_animated_sprite_2d.animation = "run"
			
			_run(direction, delta)
			
			if direction.x == 0:
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
					
		State.ATTACK:
			
			velocity.y += _gravity * delta
			
			if abs(velocity.y) < AIR_HANG_THRESHOLD:
				_gravity *= AIR_HANG_MULTIPLIER
			else:
				_gravity = START_GRAVITY
				
			_fall_timer += delta
			
			if _attack_direction.y > 0:
				_animated_sprite_2d.animation = "pogo"
			elif _attack_direction.y == 0:
				_animated_sprite_2d.animation = "attack"
			else:
				_animated_sprite_2d.animation = "attack_up"
			
			if direction.x == -_attack_direction.x:
				_run(_attack_direction, delta)
			else:
				_run(direction, delta)
			
			if Input.is_action_just_pressed("jump") and is_on_floor(): 
				velocity.y = JUMP_VELOCITY * delta
				
			
		State.DAMAGED:
			pass
				
		
		State.DEAD:
			pass
	
	if Input.is_action_just_pressed("attack") and state != State.ATTACK:
		_attack(direction)
	
	velocity.y = lerp(_prevVelocity.y, velocity.y, Y_SMOOTHING)
	velocity.y = min(velocity.y, MAX_FALL_SPEED * delta)
	
	_wasOnFloor = is_on_floor()
	_prevVelocity = velocity
	
	move_and_slide()


func set_enabled(enabled: bool, pos: Vector2) -> void:
	#print("enabled: ", enabled)
	#print("state: ", state)
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


func take_damage(amount: int, dir: Vector2) -> void:
	if _health <= 0: return
	_health -= amount
	damage_taken.emit()
	
	if is_enabled():
		state = State.DAMAGED
		velocity.y = -50000 * get_process_delta_time()
		velocity.x = dir.x * 50000 * get_process_delta_time()
		
		_tween_tint = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		_tween_tint.tween_property(_animated_sprite_2d, "modulate", Color.RED, 0.1)
		_tween_tint.tween_property(_animated_sprite_2d, "modulate", Color.WHITE, 0.1)
		_tween_tint.tween_callback(func():
			state = State.IDLE
			if _health <= 0:
				die()
		)
	else:
		if _health <= 0:
			die()


func die() -> void:
	state = State.DEAD
	velocity.x = 0
	velocity.y = 0
	_animated_sprite_2d.stop()
	_animated_sprite_2d.play("die")
	
	GameManager.reset()


func reset() -> void:
	if is_enabled():
		state = State.IDLE
	_health = 3
	_animated_sprite_2d.play("idle")


func freeze() -> void:
	velocity = Vector2.ZERO
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


func _attack(dir: Vector2) -> void:
	if not GameManager.can_player_attack: return
	AudioManager.play_audio_clip(_audio_clip, global_position)
	
	state = State.ATTACK
	(func():
		_attack_direction = dir
		
		var slash_rotation_deg: float = 0
		
		if dir.y:
			slash_rotation_deg = -90 if dir.y < 0 else 90
		else:
			slash_rotation_deg = 180
		
		_slash.rotation_degrees = slash_rotation_deg
		
		#_slash_sprite_2d.show()
		_slash_collision.disabled = false
		await get_tree().create_timer(0.2).timeout
		_slash_collision.disabled = true
		_slash_sprite_2d.hide()
		state = State.RUN
	).call_deferred()
	

func _run(dir, delta) -> void:
	velocity.x = SPEED * dir.x * delta
	if not dir.x == 0:
		_animated_sprite_2d.scale.x = -1 if dir.x >= 0 else 1


func _update_click_are_pos() -> void:
	_click_area.is_enabled = true
	match state:
		State.IDLE:
			_click_area.position = Vector2(5, -22)
		State.CROUCH:
			_click_area.position = Vector2(8, 0)
		State.RUN:
			_click_area.position = Vector2(6, -21)
		State.DISABLED:
			_click_area.is_enabled = false
		_:
			_click_area.position = Vector2(-16, -20)


func _enable_collisions() -> void:
	_collision_shape_2d.disabled = false


func _disable_collisions() -> void:
	_collision_shape_2d.disabled = true


func _on_collision_disabled_timer_timeout() -> void:
	call_deferred("_enable_collisions")


func _on_slash_body_entered(body: Node2D) -> void:
	if body is Entity:
		if body.global_position.y > global_position.y:
			await get_tree().physics_frame
			state = State.POGO_JUMP
		body.take_damage(_damage, (body.global_position - global_position).normalized())
