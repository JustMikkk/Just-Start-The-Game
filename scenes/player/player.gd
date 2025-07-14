class_name Player
extends CharacterBody2D


enum State {
	IDLE,
	RUN,
	JUMP,
	AIR,
	DEAD,
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


var _prevVelocity = Vector2.ZERO
var _lastFloorMsec = 0
var _wasOnFloor = false
var _lastJumpQueueMsec: int
var _gravity = START_GRAVITY

@onready var state: State = State.AIR
@onready var _animated_sprite_2d: AnimatedSprite2D = $"AnimatedSprite2D"


func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	
	if is_on_floor():
		_lastFloorMsec = Time.get_ticks_msec()
	elif state != State.JUMP and state != State.AIR and state != State.DEAD:
		state = State.AIR
	
	match state:
		State.JUMP:
			
			velocity.y = JUMP_VELOCITY * delta
			state = State.AIR
			
		State.AIR:
			
			if is_on_floor():
				state = State.IDLE
			
			if Input.is_action_just_released("jump"):
				velocity.y *= JUMP_CUT_MULTIPLIER
			
			run(direction, delta)
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
#			if velocity.y > 0:
#				GRAVITY = 2000
#			else:
#				GRAVITY = 1500

		State.IDLE:
			
			if Time.get_ticks_msec() - _lastJumpQueueMsec < JUMP_BUFFER_TIME or Input.is_action_just_pressed("jump"): # jump buffer
				state = State.JUMP
				
			else:
				velocity.x = 0
				
				if direction != 0:
					state = State.RUN
		
		State.RUN:
			
			run(direction, delta)
			
			if direction == 0:
				state = State.IDLE
			elif Input.is_action_just_pressed("jump"): 
				state = State.JUMP
		
		State.DEAD:
			pass


	velocity.y = lerp(_prevVelocity.y, velocity.y, Y_SMOOTHING)
	velocity.y = min(velocity.y, MAX_FALL_SPEED * delta)
	
	_wasOnFloor = is_on_floor()
	_prevVelocity = velocity
	
	move_and_slide()
	
	_handle_animation()


func set_enabled(val: bool) -> void:
	pass


func run(direction, delta):
	velocity.x = SPEED * direction * delta
	if not direction == 0:
		_animated_sprite_2d.flip_h = direction < 0


func die():
	state = State.DEAD
	velocity.x = 0
	velocity.y = 0
	_animated_sprite_2d.stop()
	_animated_sprite_2d.play("dead")


func _handle_animation() -> void:
	if (velocity.x == 0):
		_animated_sprite_2d.animation = "idle"
	else:
		_animated_sprite_2d.animation = "run"
