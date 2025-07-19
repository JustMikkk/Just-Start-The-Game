extends AudioStreamPlayer2D


func _ready() -> void:
	play()
	finished.connect(func():
		queue_free()
	)
