extends AudioStreamPlayer2D


func _ready() -> void:
	play()
	print("pal")
	finished.connect(func():
		queue_free()
		print("pal2")
	)
