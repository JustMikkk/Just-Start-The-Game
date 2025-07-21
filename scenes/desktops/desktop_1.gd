extends Desktop

const BINDOWS_BOSS = preload("res://scenes/bindows_defender/bindows_boss.tscn")
const VIRUS_BINDOW = preload("res://scenes/bindows/virus_bindow.tscn")

@export var _the_game_app: App

@export var _alert_before_appear: AlertBindow
@export var _alert_after_appear: AlertBindow
@export var _alert_before_leave: AlertBindow
@export var _alert_after_leave: AlertBindow

@export var _alert_second_cutscene: AlertBindow
@export var _alert_last_cutscene: AlertBindow

@export var _walls: Array[Area2D]

var _tween_pos: Tween
var _tween_cutscene_2: Tween
var _tween_cutscene_3: Tween

var bindows_boss: Entity

@onready var _animated_sprite_2d: AnimatedSprite2D = $BindowsDefender/AnimatedSprite2D
@onready var _gpu_particles_2d: GPUParticles2D = $"GPUParticles2D"

@onready var _bindows_defender: BindowsDefender = $BindowsDefender
@onready var _exit_right: AButton = $MoveButtons/Right
@onready var _exit_point_light_2d: PointLight2D = $MoveButtons/Right/PointLight2D

@onready var _bindows_holder: Node2D = $Bindows

@onready var _texture_progress_bar: TextureProgressBar = $Bindows/StartingGameBindow/Control/TextureProgressBar


func _ready() -> void:
	super()
	
	_exit_point_light_2d.energy = 2
	if GameManager.was_cutscene_played("desktop_1_2"):
		_the_game_app.bindow.open_bindow()
		_alert_second_cutscene.open_bindow()
		bindows_boss = BINDOWS_BOSS.instantiate()
		$Enemies.add_child(bindows_boss)
		bindows_boss.position = Vector2(-368, 208)
		_exit_right.is_enabled = false
		await get_tree().create_timer(1).timeout
		bindows_boss.start_charge_timer()
		bindows_boss.damage_taken.connect(func():
			_texture_progress_bar.value = 100 - bindows_boss._health * 10
		)
		bindows_boss.entity_died.connect(_on_bindows_defender_death)
		return
	
	if GameManager.has_player_admin and GameManager.has_player_firewall and GameManager.has_player_scissors:
		_the_game_app.bindow.bindow_open_signal.connect(cutscene_before_fight)
	
	if GameManager.was_cutscene_played(_cutscene_name): 
		return
	else:
		_exit_point_light_2d.energy = 0
	
	_alert_before_appear.alert_exit_signal.connect(_appear)
	_alert_before_leave.alert_exit_signal.connect(_leave)


func _appear() -> void:
	_animated_sprite_2d.play("appear")
	await _animated_sprite_2d.animation_finished
	_bindows_defender.enable_collisions(false)
	
	_tween_pos = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	_tween_pos.tween_interval(0.7)
	_tween_pos.tween_property(_bindows_defender, "position", Vector2(-160, -88), 0.7)
	_tween_pos.tween_callback(func():
		_alert_after_appear.open_bindow()
	)


func _leave() -> void:
	CursorManager.freeze()
	_tween_pos = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	_tween_pos.tween_interval(0.7)
	_tween_pos.tween_property(GameManager.game.camera, "zoom", Vector2(2, 2), 0.8)
	_tween_pos.tween_callback(func():
		GameManager.can_player_transform = true
		GameManager.player.set_enabled(true, CursorManager.get_global_pos()) 
	)
	_tween_pos.tween_interval(0.7)
	_tween_pos.tween_property(GameManager.game.camera, "zoom", Vector2.ONE, 0.8)
	_tween_pos.tween_interval(0.7)
	_tween_pos.tween_property(_bindows_defender, "position", Vector2(96, -160), 0.7)
	_tween_pos.tween_interval(0.3)
	_tween_pos.tween_callback(func():
		_alert_after_leave.open_bindow()
		for w in _walls:
			w.enable()
			await get_tree().create_timer(0.05).timeout
	)
	_tween_pos.tween_interval(4)
	_tween_pos.tween_property(_bindows_defender, "rotation_degrees", 90, 1)
	_tween_pos.tween_interval(0.3)
	_tween_pos.tween_callback(func():
		GameManager.game.camera.add_trauma(0.5)
		await get_tree().create_timer(0.1).timeout
		_gpu_particles_2d.restart()
	)
	_tween_pos.tween_property(_bindows_defender, "position", Vector2(584, -160), 0.2)
	_tween_pos.tween_property(_exit_point_light_2d, "energy", 2, 0.5)
	_tween_pos.tween_callback(func():
		_bindows_defender.hide()
		GameManager.set_cutscene_played(_cutscene_name)
	)


func cutscene_before_fight() -> void:
	if _tween_cutscene_2:
		_tween_cutscene_2.kill()
	
	_tween_cutscene_2 = get_tree().create_tween()
	
	_tween_cutscene_2.tween_property(_texture_progress_bar, "value", 90, 3)
	_tween_cutscene_2.tween_callback(func():
		bindows_boss = BINDOWS_BOSS.instantiate()
		$Enemies.add_child(bindows_boss)
		bindows_boss.position = Vector2(500, -208)
		_exit_right.is_enabled = false
		bindows_boss.damage_taken.connect(func():
			_texture_progress_bar.value = 100 - bindows_boss._health * 10
		)
		bindows_boss.entity_died.connect(_on_bindows_defender_death)
		await get_tree().create_timer(0.1).timeout
		GameManager.game.camera.add_trauma(0.5)
		_gpu_particles_2d.restart()
	)
	
	await get_tree().create_timer(3.5).timeout
	_tween_cutscene_2.kill()
	
	_tween_cutscene_2 = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween_cutscene_2.tween_property(bindows_boss, "position", Vector2(368, -208), 0.3)
	_tween_cutscene_2.tween_callback(func():
		_alert_second_cutscene.open_bindow()
	)
	_tween_cutscene_2.tween_interval(1)
	_tween_cutscene_2.tween_property(_texture_progress_bar, "value", 0, 2)
	_tween_cutscene_2.tween_property(bindows_boss, "position", Vector2(-368, 208), 2)
	_tween_cutscene_2.tween_interval(3)
	_tween_cutscene_2.tween_callback(func():
		bindows_boss.start_charge_timer()
		GameManager.set_cutscene_played("desktop_1_2")
	)


func _on_bindows_defender_death() -> void:
	bindows_boss.stop_fighting()
	
	_tween_cutscene_3 = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	_tween_cutscene_3.tween_property(bindows_boss, "rotation_degrees", 0, 1)
	_tween_cutscene_3.tween_property(bindows_boss, "position", Vector2(368, 208), 2)
	_tween_cutscene_3.tween_callback(func():
		_alert_last_cutscene.open_bindow()
		await get_tree().create_timer(4).timeout
		_the_game_app.bindow.exit_bindow()
		var virus1: Node2D = VIRUS_BINDOW.instantiate()
		virus1.global_position = Vector2.ZERO
		_bindows_holder.add_child(virus1)
		await get_tree().create_timer(1).timeout
		var virus2: Node2D = VIRUS_BINDOW.instantiate()
		virus2.global_position = Vector2i(randi_range(48, 980 -48), randi_range(48, 640 - 48))
		_bindows_holder.add_child(virus2)
		for i in range(100):
			var virus: Node2D = VIRUS_BINDOW.instantiate()
			virus.global_position = Vector2i(randi_range(48, 980 -48), randi_range(48, 640 - 48))
			virus.z_index = 50
			print("new virus", virus.global_position)
			_bindows_holder.add_child(virus)
			await get_tree().create_timer(0.1).timeout
		await get_tree().create_timer(5).timeout
		
		GameManager.game.transition_player.roll_the_courtain()
		
	)
	
	
	
