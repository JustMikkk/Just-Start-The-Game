extends Bindow

@export var _photo_name: String
@export var _photos: Array[Texture]

func _ready() -> void:
	super()
	
	$Inside.texture = _photos[randi_range(0, _photos.size() -1)]
	$Label.text = _photo_name
