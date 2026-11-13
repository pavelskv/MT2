extends vent_circle

@export var broken: bool = false

var left_right_move_degrees = 7

func on_click() -> void:
	if locked:
		MessageController.show_message("Инструктор", "Еще не время трогать эту арматуру.")
		return
		
	if broken:
		enabled = false
		
		# Анимация
		$BrokenSound.play()
		var tween = create_tween()
		
		tween.set_trans(Tween.TRANS_SPRING)
		tween.set_ease(Tween.EASE_IN)
		
		#tween.tween_property($Cylinder, "rotation_degrees", Vector3(0, 650, 0), rotation_speed).as_relative()
		
		
		tween.tween_property($Cylinder, "rotation_degrees", Vector3(0, left_right_move_degrees, 0), 0.1).as_relative()
		tween.tween_property($Cylinder, "rotation_degrees", Vector3(0, -left_right_move_degrees*2, 0), 0.2).as_relative()	
		tween.tween_property($Cylinder, "rotation_degrees", Vector3(0, left_right_move_degrees, 0), 0.1).as_relative()
		
		await tween.finished
		
		# Включаем лого ремонта после анимации
		$RepairLogo.visible = true
	else:
		turn_vent()
