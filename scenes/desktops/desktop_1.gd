extends Desktop

@onready var _point_light_2d: PointLight2D = $PointLight2D
@onready var _bindows_defender: Node2D = $BindowsDefender


func _on_exit_area_body_entered(body: Node2D) -> void:
	if body is not Player: return
	
	_point_light_2d.hide()
	_bindows_defender.hide()
	
	GameManager.go_to_desktop(1, false)
