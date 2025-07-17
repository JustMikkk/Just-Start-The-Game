class_name TextBindow
extends Bindow


signal writing_finished

@export_multiline var _text: String = "henlo"

@export var _autoplay: bool = true
@export var _initial_delay: float = 1
@export var _wait_interval: float = 0.06

var _is_writing: bool = false

@onready var _label: Label = $Control/Label


func _ready() -> void:
	super()
	
	if _autoplay:
		bindow_open_signal.connect(_write_text)
	else:
		_label.text = _text
		writing_finished.emit()


func _write_text() -> void:
	if _is_writing: return
	
	_is_writing = true
	_label.text = ""
	await get_tree().create_timer(_initial_delay).timeout
	
	for l in _text:
		_label.text += l
		
		var wait_interval: float = _wait_interval
		
		if l in [' ', ',', '.', ';']:
			wait_interval = _wait_interval * 3
		
		await get_tree().create_timer(wait_interval).timeout
	
	_is_writing = false
	writing_finished.emit()
