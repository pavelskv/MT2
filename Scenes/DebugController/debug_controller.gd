extends CanvasLayer

@export var debug_enabled: bool = false

@onready var check_button_err_6: CheckButton = $Panel/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/CheckButtonErr6
@onready var check_button_err_7: CheckButton = $Panel/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/CheckButtonErr7
@onready var check_button_err_8: CheckButton = $Panel/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/CheckButtonErr8
@onready var check_button_err_9: CheckButton = $Panel/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/CheckButtonErr9
@onready var check_button_err_10: CheckButton = $Panel/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/CheckButtonErr10

@onready var option_button_broken: CheckBox = $Panel/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/OptionButtonBroken

@onready var spin_box_air_gone_by: SpinBox = $Panel/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/HBoxContainer/SpinBoxAirGoneBy
@onready var spin_box_30_min: SpinBox = $Panel/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/HBoxContainer2/SpinBox30Min

@onready var water_pool_speed: SpinBox = $Panel/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/HBoxContainer3/WaterPoolSpeed

@onready var check_button_random: CheckButton = $Panel/MarginContainer/VBoxContainer/CheckButtonRandom


func read_params() -> void:
	check_button_err_6.button_pressed = %RoomController.error6
	check_button_err_7.button_pressed = %RoomController.error7
	check_button_err_8.button_pressed = %RoomController.error8
	check_button_err_9.button_pressed = %RoomController.error9
	check_button_err_10.button_pressed = %RoomController.error10
	
	option_button_broken.button_pressed = %Pump2Valve1.broken
	
	spin_box_air_gone_by.value = %RoomController/WaitForAirGoneByTimer.wait_time
	spin_box_30_min.value = %RoomController/Timer30min.total_seconds
	
	water_pool_speed.value = %WaterPool.speed_in_sec
	
	
func set_params() -> void:
	%RoomController.error6 = check_button_err_6.button_pressed
	%RoomController.error7 = check_button_err_7.button_pressed
	%RoomController.error8 = check_button_err_8.button_pressed
	%RoomController.error9 = check_button_err_9.button_pressed
	%RoomController.error10 = check_button_err_10.button_pressed
	
	%Pump2Valve1.broken = option_button_broken.button_pressed
	
	%RoomController/WaitForAirGoneByTimer.wait_time = spin_box_air_gone_by.value
	%RoomController/Timer30min.total_seconds = spin_box_30_min.value
	%RoomController/TimerOneMinute.wait_time = spin_box_30_min.value + 0.5
	
	%WaterPool.speed_in_sec = water_pool_speed.value

		
func _process(_delta: float) -> void:
	if not debug_enabled: return
	
	if Input.is_action_just_pressed("1") or Input.is_action_just_pressed("2") \
	or Input.is_action_just_pressed("3") or Input.is_action_just_pressed("4") \
	or Input.is_action_just_pressed("5") or Input.is_action_just_pressed("6"):
	
		if not visible and not $"../StartMenu".visible and not $"../Briefing".visible \
		and not (LossScreen.visible or RetryScreen.visible or WinScreen.visible or %Switch2D.visible):
			$"../HelpMenu".visible = false
			visible = true
		
		
func _on_visibility_changed() -> void:
	if visible:
		read_params()
		get_tree().paused = true
		GameController.is_cutscene = true
		GameController.mouse_visible = true
	else:
		get_tree().paused = false
		
		GameController.mouse_visible = false
		GameController.is_cutscene = false


func _on_cancel_button_pressed() -> void:
	visible = false

func _on_ok_button_pressed() -> void:
	set_params()
	visible = false

func _on_water_pool_test_pressed() -> void:
	%WaterPool.speed_in_sec = water_pool_speed.value
	%WaterPool.become_large()
	visible = false

func _on_water_pool_default_pressed() -> void:
	%WaterPool.become_default()
	visible = false


func debug_radiobuttons_enabled(enabled: bool) -> void:
	get_tree().set_group("debug_radiobuttons", "disabled", !enabled)
	
	#check_button_err_6.disabled = !enabled
	#check_button_err_7.disabled = !enabled
	#check_button_err_8.disabled = !enabled
	#check_button_err_9.disabled = !enabled
	#check_button_err_10.disabled = !enabled
	#option_button_broken.disabled = !enabled


func _on_check_button_random_toggled(toggled_on: bool) -> void:
	if toggled_on:
		debug_radiobuttons_enabled(false)

		var rand_err_number: int = randi_range(6, 10)
		match rand_err_number:
			6: check_button_err_6.button_pressed = true
			7: check_button_err_7.button_pressed = true
			8: check_button_err_8.button_pressed = true
			9: check_button_err_9.button_pressed = true
			10: check_button_err_10.button_pressed = true
			
		option_button_broken.button_pressed = randi_range(0, 1)
	else:
		get_tree().set_group("debug_radiobuttons", "button_pressed", false)
		
		#check_button_err_6.button_pressed = false
		#check_button_err_7.button_pressed = false
		#check_button_err_8.button_pressed = false
		#check_button_err_9.button_pressed = false
		#check_button_err_10.button_pressed = false
		#option_button_broken.button_pressed = false
		
		debug_radiobuttons_enabled(true)
