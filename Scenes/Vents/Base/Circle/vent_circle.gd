class_name vent_circle extends Node3D

signal has_rotated(is_opened: bool)

var is_animating: bool = false

## Активен ли вентиль для взаимодействия
@export var enabled: bool = true:
	set(value):
		enabled = value
		_make_enabled(value)
	get: return(enabled)


## Вентиль открыт/закрыт
@export var is_opened: bool = false:
	set(value):
		is_opened = value
	get:
		if is_animating: 
			return !is_opened
		else: return is_opened


## Скорость поворота вентиля
@export var rotation_speed: float = 2.2

var opened_state_caption = "Закрыть вентиль"
var closed_state_caption = "Открыть вентиль"

## Еще не время трогать эту арматуру
@export var locked: bool = false


func on_click() -> void:
	if locked:
		MessageController.show_message("Инструктор", "Еще не время трогать эту арматуру.")
	else: turn_vent()
	
func _ready() -> void:
	# Check if is_opened at the end of own _ready func, because
	# game/room_controllers could change vents is_opened state in their own _ready func
	# so we need vents to act AFTER game/room_controllers _ready code
	call_deferred("_is_opened_check")

func _is_opened_check():	
	_make_enabled(enabled)
	
	if is_opened:
		$Vent_Roud_Stick.position += Vector3(0, 0.07, 0)
		$Label3D.text = opened_state_caption  
	else: $Label3D.text = closed_state_caption

func _make_enabled(value : bool):
	$Cylinder/StaticBody3D.set_collision_layer_value(2, value)
	$Vent_Roud_Stick/ventil_001/StaticBody3D.set_collision_layer_value(2, value)	

func focused(is_focused: bool):
	$Label3D.visible = is_focused
	$Cylinder.material_overlay.next_pass.set_shader_parameter("enable", is_focused)
	
# open/close vent
func turn_vent():	
	if is_animating: return
	else: is_animating = true
	
	
	$TurnSound.play()
	var tween = create_tween()
	
	# animation parameters
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)

	if is_opened:
		tween.tween_property($Cylinder, "rotation_degrees", Vector3(0, 650, 0), rotation_speed).as_relative()
		tween.parallel().tween_property($Vent_Roud_Stick, "position", Vector3(0, 0.07, 0), rotation_speed).as_relative()
		await tween.finished
	
		$Label3D.text = opened_state_caption
		is_opened = true
	else:
		tween.tween_property($Cylinder, "rotation_degrees", Vector3(0, -650, 0), rotation_speed).as_relative()
		tween.parallel().tween_property($Vent_Roud_Stick, "position", Vector3(0, -0.07, 0), rotation_speed).as_relative()
		await tween.finished
		
		$Label3D.text = closed_state_caption
		is_opened = false
	
	is_animating = false
	
	# emit signal about vent has been rotated
	has_rotated.emit(is_opened)

func _on_vent_1_st_set_focused(is_focused: bool) -> void:
	focused(is_focused)

func _on_vent_1_st_set_on_click() -> void:
	on_click()
