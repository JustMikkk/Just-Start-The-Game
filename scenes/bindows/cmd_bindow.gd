extends Bindow

@export var text: String = "henlo"

var _letter_index: int = 0

@onready var label: Label = $Control/Label


func _ready() -> void:
	super()
	
	bindow_open_signal.connect(_write_text)


func _write_text() -> void:
	label.text = ""
	await get_tree().create_timer(1).timeout
	
	
	for l in text:
		label.text += l
		
		var wait_interval: float = 0.06
		
		if l == " ":
			wait_interval = 0.15
		
		await get_tree().create_timer(wait_interval).timeout
	
