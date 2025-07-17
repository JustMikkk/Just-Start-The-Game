extends Label


func _ready() -> void:
	_on_update_timer_timeout()


func _on_update_timer_timeout() -> void:
	var hours: int = Time.get_datetime_dict_from_system()["hour"]
	var minutes: int = Time.get_datetime_dict_from_system()["minute"]
	var seconds: int = Time.get_datetime_dict_from_system()["second"]
	
	var display_string: String = str(
			"0" if hours < 10 else "",
			hours,
			":",
			"0" if minutes < 10 else "",
			minutes,
			":",
			"0" if seconds < 10 else "",
			seconds,
	)
	
	text = display_string
