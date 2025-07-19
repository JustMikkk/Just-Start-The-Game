extends Node2D

const AUDIO_PLAYER = preload("res://scenes/audio/audio_player.tscn")


func play_audio_clip(clip: AudioStream, global_pos: Vector2) -> void:
	var audio_player: AudioStreamPlayer2D = AUDIO_PLAYER.instantiate()
	
	audio_player.stream = clip
	audio_player.global_position = global_pos
	add_child(audio_player)
