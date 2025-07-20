extends Area2D

@export var is_disabled: bool = false
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D


func _ready() -> void:
	if GameManager.has_player_admin:
		queue_free()
	
	if is_disabled:
		(func():
			$CollisionShape2D.disabled = true
		).call_deferred()
		scale = Vector2.ZERO
		gpu_particles_2d.emitting = false

	GameManager.adminwall_equipped.connect(func():
		queue_free()
	)


func enable() -> void:
	(func():
		$CollisionShape2D.disabled = false
	).call_deferred()
	get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).tween_property(self, "scale", Vector2.ONE, 0.7)


func _on_body_entered(body: Node2D) -> void:
	if not GameManager.has_player_admin:
		GameManager.player.take_damage(999, Vector2.ZERO)
