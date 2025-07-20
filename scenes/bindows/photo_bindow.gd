extends Bindow

@export var _photo_name: String

func _ready() -> void:
	super()
	
	$Label.text = _photo_name
