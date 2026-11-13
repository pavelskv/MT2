extends Node

var visible: bool = false

var ready_to_restart: bool

signal win_screen_show

func show() -> void:
	
	GameController.mouse_visible = true
	ready_to_restart = false
	
	win_screen_show.emit()
	visible = true
	MessageController.stop_messages()
	GameController.is_cutscene = true
	
	RBCM_GameClient.find_node("%EscMenu").visible = false
	
	%WinScreen.visible = true
	
	%Sound.play()

func _on_win_sound_finished() -> void:
	ready_to_restart = true
	pass


func _on_to_main_menu_button_pressed():
	
	%WinScreen.visible = false
	visible = false
	GameController.mouse_visible = true
	GameController.first_start_occured = false
	
	GameController.restart_level(true)
