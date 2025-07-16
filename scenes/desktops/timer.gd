extends Label


func _on_update_timer_timeout() -> void:
	text = str(Time.get_datetime_dict_from_system()["hour"], ":", Time.get_datetime_dict_from_system()["minute"])
