extends Node

var ready_to_restart: bool

var visible: bool = false

signal loss_screen_show

func show() -> void:
	
	ready_to_restart = false
	
	loss_screen_show.emit()
	visible = true
	
	MessageController.stop_messages()
	GameController.is_cutscene = true
	
	RBCM_GameClient.find_node("%EscMenu").visible = false
	
	%LossScreen.visible = true
	RBCM_GameClient.find_node("%Pump2WaterCircleDrops/AudioStreamPlayer3D").stop()
	%Sound.play()
	
func _on_sound_finished() -> void:
	ready_to_restart = true

func _process(_delta: float) -> void:
	if ready_to_restart:	
		if Input.is_anything_pressed():
			
			ready_to_restart = false
			GameController.is_cutscene = false
			%LossScreen.visible = false
			visible = false
			
			GameController.restart_level(false)
