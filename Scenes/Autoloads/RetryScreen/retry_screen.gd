extends Node

var ready_to_restart: bool

var visible: bool = false

signal retry_screen_show
	
func show() -> void:
	ready_to_restart = false
	
	retry_screen_show.emit()
	visible = true
	
	MessageController.stop_messages()
	GameController.is_cutscene = true
	
	RBCM_GameClient.find_node("%EscMenu").visible = false
	
	%RetryScreen.visible = true
	RBCM_GameClient.find_node("%Pump2WaterCircleDrops/AudioStreamPlayer3D").stop()
	%Sound.play()
	
func _on_sound_finished() -> void:
	ready_to_restart = true

func _process(_delta: float) -> void:
	if ready_to_restart:	
		if Input.is_anything_pressed():
			
			ready_to_restart = false
			GameController.is_cutscene = false
			%RetryScreen.visible = false
			visible = false
			
			GameController.restart_level(true)
