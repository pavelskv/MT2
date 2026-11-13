extends Node3D

func _ready() -> void:
	GameController.mouse_visible = true
	GameController.is_cutscene = true
	pass
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("8"):
		WinScreen.show()
		pass
		
	if Input.is_action_just_pressed("9"):
		LossScreen.show()
	pass
	
	#if Input.is_action_just_pressed("enter"):
		#%Pump1.podshipnik_heat = true
		#%Pump1.full_power = true
		
		
		#%PumpFlowController/Slider.jump_step = 80
		
		
		
		
		
		#%Pump1Sensor2.set_pressure(1.5)
		#%Pump1Sensor1.set_pressure_017()
		#
		#await %RoomController.wait(5)
		#
		#
		#%Pump1Sensor2.set_pressure_0()
		#%Pump1Sensor1.set_pressure_0()
		
		
		
	
		
		#await %RoomController.wait(3)
		#await %RoomController.cutscene_ended
		#print(randi())


		#await get_tree().create_timer(5).timeout
		#GameController.restart_level()
		#await %RoomController.wait(3)
		#%PumpFlowController.slider_wheel_enabled = !%PumpFlowController.slider_wheel_enabled 
		#pass
		#%DebugController.visible = true
		#print("%Pump2Valve1.broken ", %Pump2Valve1.broken)
		#print("%RoomController.error6 ", %RoomController.error6)
		#print("%RoomController.error7 ", %RoomController.error7)
		#print("%RoomController.error8 ", %RoomController.error8)
		#print("%RoomController.error9 ", %RoomController.error9)
		#print("%RoomController.error10 ", %RoomController.error10)
		#%WaterPool.become_large()
		
		#MessageController.show_message("", "За недостаточный контроль за работой НА (длительную работу с недопустимо высокой вибрацией, в результате которой НА вышел из строя), инженер НО и ВИУР от работы отстранены с пересдачей экзамена по ОПЭ АС.", "res://Assets/Sound/Voice/Manual/error6_after_one_minute_fail.mp3")
		
		
		
		#%RoomController/FinalTimer.start()
		#%RoomController/FinalTimer/FinalTimer_UI.visible = true
		
		#%RoomController.error6_active = true
		#%Pump1.full_power = true
		
		#%RoomController.set_vibration_value("11.2")
		#%CutsceneErr7.visible = true
		#%Pump1.full_power = true
		#%PumpFlowController.enabled = true
		#%PumpFlowController.slider_wheel_down_enabled = true
		#
		#await get_tree().create_timer(20).timeout
		
		#%RoomController/FinalTimer.start()
		#%RoomController.FinalTimer_UI.visible = true
		#%Pump1.set_defaults()
		#%Pump1.full_power = false
		
		
		#%Shups.visible = !%Shups.visible
		#%RoomController.start_30min_timer()
		#print(%RoomController/Timer30min.minutes)
		
		#RetryScreen.show()
		
	# DEBUG
	#if not GameController.is_cutscene:
		#
		#if Input.is_action_just_pressed("1"):
			#%Pump2Valve1.broken = !%Pump2Valve1.broken
		#
			#if %Pump2Valve1.broken:
				##if not %Pump2Valve1.is_opened:
				##	%Pump2Valve1.turn_vent()
				#MessageController.show_message("", "Для тестирования выбрана ошибка номер 3 - не закрывается от штурвала арматура на всасе насоса 2.")
			#else:
				##if %Pump2Valve1.is_opened:
				##	%Pump2Valve1.turn_vent()
				#MessageController.show_message("", "Ошибка номер 3 отключена - арматура на всасе насоса 2 исправна.")
			#
		#if Input.is_action_just_pressed("2"):
			#%RoomController.error6 = true
			#%RoomController.error7 = false
			#%RoomController.error8 = false
			#%RoomController.error9 = false
			#%RoomController.error10 = false
			#MessageController.show_message("", "Для тестирования выбрана ошибка номер 6 - повышенная вибрация электродвигателя, ослабление крепежа (при расходе 2,8).")
			#
		#if Input.is_action_just_pressed("3"):
			#%RoomController.error6 = false
			#%RoomController.error7 = true
			#%RoomController.error8 = false
			#%RoomController.error9 = false
			#%RoomController.error10 = false
			#MessageController.show_message("", "Для тестирования выбрана ошибка номер 7 - снижение давления на всасе, кавитация (при расходе 4,2).")
			#
		#if Input.is_action_just_pressed("4"):
			#%RoomController.error6 = false
			#%RoomController.error7 = false
			#%RoomController.error8 = true
			#%RoomController.error9 = false
			#%RoomController.error10 = false
			#MessageController.show_message("", "Для тестирования выбрана ошибка номер 8 - выход из строя задвижки на линии рециркуляции. Не управляется (при расходе 5,6).")
			#
		#if Input.is_action_just_pressed("5"):
			#%RoomController.error6 = false
			#%RoomController.error7 = false
			#%RoomController.error8 = false
			#%RoomController.error9 = true
			#%RoomController.error10 = false
			#MessageController.show_message("", "Для тестирования выбрана ошибка номер 9 - повышенный нагрев подшипника (при расходе 6,9).")
			#
		#if Input.is_action_just_pressed("6"):
			#%RoomController.error6 = false
			#%RoomController.error7 = false
			#%RoomController.error8 = false
			#%RoomController.error9 = false
			#%RoomController.error10 = true
			#MessageController.show_message("", "Для тестирования выбрана ошибка номер 10 - повышенный объем протечки по уплотнению вала насоса (при расходе 8,2).")
	#
	#
	
	
	
	
