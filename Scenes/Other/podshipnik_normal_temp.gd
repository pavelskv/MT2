extends MeshInstance3D

func focused(is_focused: bool):
	if not GameController.pump1_running:
		return
	
	
	
	if not GameController.sensor_visible:
		%Character.set_pirometr_value(45)
		%Character.is_pirometr_visible = is_focused
	else: %Character.is_pirometr_visible = false
	
	#%Shups.visible = $VibrationDevice.visible
	
func on_click() -> void:
	if not GameController.pump1_running:
		return
		
	if not GameController.is_cutscene: #and $VibrationDevice.visible:
		pass
		#if %RoomController.error9 and %Pump1.podshipnik_heat:
			#MessageController.show_message("", "Температура существенно выше нормы.")
		#else:
			###MessageController.show_message("", "Температура в норме.")

