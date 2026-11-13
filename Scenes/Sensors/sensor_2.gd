extends Node3D
class_name sensor2

## Скорость поворота стрелки в секундах.
@export var rotation_speed : float = 2.2

var is_animating : bool = false


var min_rotation: float = -2.7
var max_rotation: float = -270.2

var min_value: float = 0
var max_value: float = 1.6

var rotation_percent: float = (max_rotation - min_rotation) / 100
var value_percent: float = (max_value - min_value) / 100



func recalculate_rotation(min_rot: float, max_rot: float, min_val: float, max_val: float):
	min_rotation = min_rot
	max_rotation = max_rot
	min_value = min_val
	max_value = max_val
	
	rotation_percent = (max_rotation - min_rotation) / 100
	value_percent = (max_value - min_value) / 100
	



func focused(is_focused: bool):
	$SensorZoomOverlay.visible = is_focused
	GameController.sensor_visible = is_focused
	
	if name == "Pump1Sensor2" and %Pump1.full_power: # and %PumpFlowController.enabled:
		$RNH.visible = is_focused
		
	
	
func _process(_delta: float) -> void:
	pass
	
	## DEBUG
	#print($SensorArrow.rotation_degrees.x)
	
	#if Input.is_action_pressed("left"):
		#$SensorArrow.rotation_degrees.x += 1
		#
	#if Input.is_action_pressed("right"):
		#$SensorArrow.rotation_degrees.x -= 1
		#
	#if Input.is_action_just_pressed("alt"):
		#set_pressure(0.8)
		#set_pressure_017()
		#set_pressure_08()
		#set_pressure(1)
			
	


func set_pressure(value: float, speed: float = rotation_speed):
	if is_animating: return
	else: is_animating = true
	
	if value >= 0.0 and value <= 0.1: recalculate_rotation(-2.70,  -14.5,  0.0, 0.1)
	if value > 0.1 and value <= 0.2: recalculate_rotation(-14.5,  -30.5,  0.1, 0.2)
	if value > 0.2 and value <= 0.3: recalculate_rotation(-30.5,  -46.5,  0.2, 0.3)
	if value > 0.3 and value <= 0.4: recalculate_rotation(-46.5,  -63.3,  0.3, 0.4)
	if value > 0.4 and value <= 0.5: recalculate_rotation(-63.3,  -80.0,  0.4, 0.5)
	if value > 0.5 and value <= 0.6: recalculate_rotation(-80.0,  -97.4,  0.5, 0.6)
	if value > 0.6 and value <= 0.7: recalculate_rotation(-97.4,  -114.7, 0.6, 0.7)
	if value > 0.7 and value <= 0.8: recalculate_rotation(-114.7, -132.0, 0.7, 0.8)
	if value > 0.8 and value <= 0.9: recalculate_rotation(-132.0, -149.3, 0.8, 0.9)
	if value > 0.9 and value <= 1.0: recalculate_rotation(-149.3, -166.3, 0.9, 1.0)
	if value > 1.0 and value <= 1.1: recalculate_rotation(-166.3, -183.5, 1.0, 1.1)
	if value > 1.1 and value <= 1.2: recalculate_rotation(-183.5, -200.6, 1.1, 1.2)
	if value > 1.2 and value <= 1.3: recalculate_rotation(-200.6, -217.8, 1.2, 1.3)
	if value > 1.3 and value <= 1.4: recalculate_rotation(-217.8, -235.0, 1.3, 1.4)
	if value > 1.4 and value <= 1.5: recalculate_rotation(-235.0, -252.8, 1.4, 1.5)
	if value > 1.5 and value <= 1.6: recalculate_rotation(-252.8, -270.2, 1.5, 1.6)
	
	var current_value_percent: float = (value - min_value) / value_percent 
	var new_rotation: float = min_rotation + current_value_percent * rotation_percent
	
	var tween = create_tween()
	
	# animation parameters
	tween.set_trans(Tween.TRANS_SPRING)
	#tween.set_ease(Tween.EASE_OUT)

	tween.tween_property($SensorArrow, "rotation_degrees:x", new_rotation, speed)
	await tween.finished
	
	is_animating = false
	
	
######################### OTHER WAYS
# Установить нулевое давление
func set_pressure_0(speed: float = rotation_speed):	
	min_rotation = -2.7
	
	if is_animating: return
	else: is_animating = true

	var tween = create_tween()
	
	# animation parameters
	#tween.set_trans(Tween.TRANS_SPRING)
	#tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property($SensorArrow, "rotation_degrees", Vector3(min_rotation, 0, 0), speed)
	await tween.finished
	
	is_animating = false
	
# Установить давление на отметке 0.1
func set_pressure_01():	
	set_pressure(0.1)
	return
	
	#if is_animating: return
	#else: is_animating = true
#
	#var tween = create_tween()
	#
	## animation parameters
	#tween.set_trans(Tween.TRANS_SPRING)
	##tween.set_ease(Tween.EASE_OUT)
	#
	#tween.tween_property($SensorArrow, "rotation_degrees", Vector3(-26, 0, 0), rotation_speed)
	#await tween.finished
	#
	#is_animating = false
	

# Установить давление на отметке 0.17
func set_pressure_017():	
	set_pressure(0.17)
	return
	
	#if is_animating: return
	#else: is_animating = true
	#
	#var tween = create_tween()
	#
	## animation parameters
	#tween.set_trans(Tween.TRANS_SPRING)
	##tween.set_ease(Tween.EASE_OUT)
	#
	#tween.tween_property($SensorArrow, "rotation_degrees", Vector3(-45, 0, 0), rotation_speed)
	#await tween.finished
	#
	#is_animating = false


# Установить давление на отметке 0.8
func set_pressure_08():	
	set_pressure(0.8)
	return
	
	#if is_animating: return
	#else: is_animating = true
	#
	#var tween = create_tween()
	#
	## animation parameters
	#tween.set_trans(Tween.TRANS_SPRING)
	##tween.set_ease(Tween.EASE_OUT)
#
	#tween.tween_property($SensorArrow, "rotation_degrees", Vector3(-132, 0, 0), rotation_speed)
	#await tween.finished
	#
	#is_animating = false

