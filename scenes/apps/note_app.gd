extends App

@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	super()
	
	app_opened_signal.connect(_on_app_opened)
	app_exited_signal.connect(_on_app_closed)
	


func _on_app_opened(_app: App) -> void:
	_animated_sprite_2d.play("transform_into")
	
	await _animated_sprite_2d.animation_finished
	
	_animated_sprite_2d.play("transformed_idle")


func _on_app_closed(_app: App) -> void:
	_animated_sprite_2d.play("transform_back")
