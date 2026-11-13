class_name vent_straight_breakable extends vent_straight

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
		
		tween.tween_property($ventil_004, "rotation_degrees", Vector3(0, left_right_move_degrees, 0), 0.1).as_relative()
		tween.tween_property($ventil_004, "rotation_degrees", Vector3(0, -left_right_move_degrees*2, 0), 0.2).as_relative()	
		tween.tween_property($ventil_004, "rotation_degrees", Vector3(0, left_right_move_degrees, 0), 0.1).as_relative()
		
		await tween.finished
		
		# Включаем лого ремонта после анимации
		$RepairLogo.visible = true
	else:
		turn_vent()


func _on_broken_vent_notify_timer_timeout() -> void:
	$RepairLogo.visible = false
	$BrokenVentNotifyTimer/BrokenNotify.visible = true
	$BrokenVentNotifyTimer/BrokenNotify/VentFixedConfirmationSound.play()


func _on_vent_fixed_confirmation_sound_finished() -> void:
	$BrokenVentNotifyTimer/BrokenNotify.visible = false

	enabled = true
	locked = false
	
	broken = false


func StartBrokenVentNotifyTimer() -> void:
	$BrokenVentNotifyTimer.start()
