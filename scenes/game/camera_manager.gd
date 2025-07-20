class_name CameraManager
extends Camera2D

@export var _decay: float = 0.8 # Time it takes to reach 0% of trauma
@export var _max_offset: Vector2 = Vector2(100, 75) # Max hor/ver shake in pixels
@export var _max_roll: float = 0.1 # Maximum rotation in radians (use sparingly)


var _trauma: float = 0.0 # Current shake strength
var _trauma_power: int = 2 # Trauma exponent. Increase for more extreme shaking
@onready var follow_node: Node2D = CursorManager.get_follow_node()


func _ready() -> void:
	#? Randomize the game seed
	randomize()

func _process(delta : float) -> void:
	if follow_node: # If the follow node exists
		global_position = follow_node.global_position # Set the camera's position to the follow node's position
	if _trauma: # If the camera is currently shaking
		_trauma = max(_trauma - _decay * delta, 0) # Decay the shake strength
		shake() # Shake the camera

## The function to use for adding trauma (screen shake)
func add_trauma(amount : float) -> void:
	_trauma = min(_trauma + amount, 1.0) # Add the amount of trauma (capped at 1.0)

## This function is used to actually apply the shake to the camera
func shake() -> void:
	#? Set the camera's rotation and offset based on the shake strength
	var amount = pow(_trauma, _trauma_power)
	rotation = _max_roll * amount * randf_range(-1, 1)
	offset.x = _max_offset.x * amount * randf_range(-1, 1)
	offset.y = _max_offset.y * amount * randf_range(-1, 1)
