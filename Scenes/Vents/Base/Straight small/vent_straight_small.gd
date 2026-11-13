class_name vent_straight_small extends Node3D

signal has_rotated(is_opened: bool)

var is_animating: bool = false

## Активен ли вентиль для взаимодействия
@export var enabled: bool = true:
	set(value):
		enabled = value
		_make_enabled(value)
	get: return enabled


## Вентиль открыт/закрыт
@export var is_opened: bool = false:
	set(value):
		is_opened = value
	get:
		if is_animating: 
			return !is_opened
		else: return is_opened
		


## Скорость поворота вентиля
@export var rotation_speed: float = 0.6

var opened_state_caption = "Закрыть вентиль"
var closed_state_caption = "Открыть вентиль"

## Еще не время трогать эту арматуру
@export var locked: bool = false


func on_click() -> void:
	if locked:
		MessageController.show_message("Инструктор", "Еще не время трогать эту арматуру.")
	else: turn_vent()
	
func _ready() -> void:
	# check if is_opened at the end of own _ready func, because
	# game/room_controllers could change vents is_opened state in their own _ready func
	# so we need vents to act AFTER game/room_controllers _ready code
	call_deferred("_is_opened_check")
	
func _is_opened_check():
	_make_enabled(enabled)
	
	if is_opened:
		%Label3D.text = opened_state_caption
		$vent_vozd.rotation_degrees += Vector3(90, 0, 0)
	else: %Label3D.text = closed_state_caption
		

func _make_enabled(value : bool):
	$vent_vozd/StaticBody3D.set_collision_layer_value(2, value)

func focused(is_focused: bool):
	%Label3D.visible = is_focused
	$vent_vozd.material_overlay.next_pass.set_shader_parameter("enable", is_focused)
	
# open/close vent
func turn_vent():	
	if is_animating: return
	else: is_animating = true

	$TurnSound.play()
	var tween = create_tween()
	
	# animation parameters
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	
	if is_opened:
		tween.tween_property($vent_vozd, "rotation_degrees", Vector3(90, 0, 0), rotation_speed).as_relative()
		await tween.finished
	
		%Label3D.text = opened_state_caption  
		is_opened = true
		is_animating = false
	else:
		tween.tween_property($vent_vozd, "rotation_degrees", Vector3(-90, 0, 0), rotation_speed).as_relative()
		await tween.finished
		
		$Label3D.text = closed_state_caption
		is_opened = false
		is_animating = false
		
		
	# emit signal about vent has been rotated
	has_rotated.emit(is_opened)

