class_name sensor1 extends Node3D


## Скорость поворота стрелки в секундах.
@export var rotation_speed : float = 2.2

var is_animating : bool = false


func focused(is_focused: bool):
	$SensorZoomOverlay.visible = is_focused
	GameController.sensor_visible = is_focused


# Установить давление на отметке 0.17 или вернуть в ноль
func set_pressure_017():	
	if is_animating: return
	else: is_animating = true
	
	var tween = create_tween()
	
	# animation parameters
	tween.set_trans(Tween.TRANS_SPRING)
	#tween.set_ease(Tween.EASE_OUT)

	tween.tween_property($SensorArrow, "rotation_degrees", Vector3(-211, 0, 0), rotation_speed)
	await tween.finished
	
	is_animating = false


# Установить нулевое давление
func set_pressure_0(speed: float = rotation_speed):
	if is_animating: return
	else: is_animating = true
	
	var tween = create_tween()
	
	# animation parameters
	#tween.set_trans(Tween.TRANS_SPRING)
	#tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property($SensorArrow, "rotation_degrees", Vector3(3, 0, 0), speed)
	await tween.finished
	
	is_animating = false
