extends Entity


var dir := Vector2(1, 1)
var speed: float = 200


func _ready() -> void:
	damage_taken.connect(func():
		dir *= -1
	)


func _physics_process(delta: float) -> void:
	
	rotation_degrees += delta * 100
	
	if global_position.y > 542: 
		dir.y = -1
	if global_position.y < 50:
		dir.y = 1
	
	if global_position.x > 910:  
		dir.x = -1
	
	if global_position.x < 50:
		dir.x = 1
	
	
	velocity = dir * speed
	
	move_and_slide()


func _briefly_disable_collisions() -> void:
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(0.2).timeout
	$CollisionShape2D.disabled = false



func _on_damage_area_body_entered(body: Node2D) -> void:
	body.take_damage(1, Vector2.ZERO)
