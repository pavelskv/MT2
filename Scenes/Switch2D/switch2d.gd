extends CanvasLayer

var knobs_on: int = 0

func _ready():
	await get_tree().process_frame
	visibility_changed.connect(_on_visibility_changed)

func _process(_delta: float) -> void:
	if knobs_on == 7:
		knobs_on = 0
		
		for node in %Knobs.get_children():
			node.enabled = false
		
		$TaskFinished.start()
		


func on_off_light(light_block_number: int, current_state: bool) -> void:
	if current_state: knobs_on += 1
	else: knobs_on -= 1
	
	await get_tree().create_timer(0.3).timeout
	#await RBCM_GameClient.find_node("%RoomController").wait(0.3)
	
	$Panel/SwitchLamp.play()
	
	get_node("Panel/Lights/Red" + str(light_block_number)).visible = !current_state
	get_node("Panel/Lights/Green" + str(light_block_number)).visible = current_state
	
	
	

func _on_knob_1_state_changed(current_state: bool) -> void:
	on_off_light(1, current_state)


func _on_knob_2_state_changed(current_state: bool) -> void:
	on_off_light(2, current_state)


func _on_knob_3_state_changed(current_state: bool) -> void:
	on_off_light(3, current_state)


func _on_knob_4_state_changed(current_state: bool) -> void:
	on_off_light(4, current_state)


func _on_knob_5_state_changed(current_state: bool) -> void:
	on_off_light(5, current_state)


func _on_knob_6_state_changed(current_state: bool) -> void:
	on_off_light(6, current_state)


func _on_knob_7_state_changed(current_state: bool) -> void:
	on_off_light(7, current_state)


func _on_visibility_changed() -> void:
	if visible:
		GameController.is_cutscene = true
		GameController.mouse_visible = true
	else:
		GameController.mouse_visible = false
		GameController.is_cutscene = false

func _on_task_finished_timeout() -> void:
	GameController.switch_done = true
	visible = false
