extends CanvasLayer

signal pause_started
signal pause_finished

func show_esc_menu(_args):
	if screen_check():
		visible = true

		# Отключить отображение меню "задач"
		$Control/Tasks_menu.visible = false
		$Control/Materials_menu.visible = false
		visibility(true)
	
func screen_check() -> bool:
	# Проверяет можно ли показать ESC-меню
	return not any_screen_visible()
		
func any_screen_visible() -> bool:
	var screens = [
		self,
		$"../StartMenu",
		LossScreen,
		RetryScreen,
		WinScreen,
		%DebugController,
		%Briefing,
		%Switch2D,
		$"../Tasks_menu"
	]
	return screens.any(func(screen): return screen.visible)
	
func _ready():
	await get_tree().process_frame
	visibility_changed.connect(_on_visibility_changed)
	
func _process(_delta: float) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		show_esc_menu(null)
	else:
		if visible: 
			set_deferred("visible", false)

	# Game pause
	if Input.is_action_just_pressed("escape"):
		show_esc_menu(null)

func _on_visibility_changed() -> void:
	if visible:
		GameController.mouse_visible = true
		get_tree().paused = true
		pause_started.emit()
	else:
		GameController.mouse_visible = false
		get_tree().paused = false
		pause_finished.emit()
		

func _on_resume_button_pressed() -> void:
	visible = false
	$"../Character"/CenterContainer.visible = true

func _on_restart_button_pressed() -> void:
	#visible = false
	get_tree().paused = false
	pause_finished.emit()
	GameController.restart_level()

func visibility(val: bool) -> void:
	if val:
		$Control/MarginLabel.visible = true
		$Control/VBoxContainerMenu.visible = true
		$Control/MarginKeyboard.visible = true
		$Control/MarginMouse.visible = true
	else:
		$Control/MarginLabel.visible = false
		$Control/VBoxContainerMenu.visible = false
		$Control/MarginKeyboard.visible = false
		$Control/MarginMouse.visible = false

func _on_task_button_pressed():
	# Выключить меню паузы
	visibility(false)
	
	# Заменить его на меню с информацией о задачах
	$Control/Tasks_menu.visible = true


func _on_materials_button_pressed():
	# Выключить меню паузы
	visibility(false)
	
	# Заменить его на меню с информацией о задачах
	$Control/Materials_menu.visible = true
