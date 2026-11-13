extends Node3D
class_name pump1

@onready var orig_transform = transform.origin

@onready var repair_logos_node: Node3D = $Motor/Nut_LP_021/RepairLogos
@onready var repair_logo_1_node: Sprite3D = $Motor/Nut_LP_021/RepairLogos/RepairLogo1
@onready var repair_logo_2_node: Sprite3D = $Motor/Nut_LP_021/RepairLogos/RepairLogo2
@onready var repair_logo_3_node: Sprite3D = $Motor/Nut_LP_021/RepairLogos/RepairLogo3
@onready var repair_logo_4_node: Sprite3D = $Motor/Nut_LP_021/RepairLogos/RepairLogo4

@onready var shake_logos_node: Node3D = $Motor/Nut_LP_021/ShakeLogos


var working_less_min: bool = true

var repair_logos: bool = false:
	get: return repair_logos
	set(value):
		repair_logos = value
		repair_logos_node.visible = repair_logos
		
var shake_logos: bool = false:
	get: return shake_logos
	set(value):
		shake_logos = value
		shake_logos_node.visible = shake_logos


var full_power: bool = false:
	set(value):
		if %RoomController.air_gone_by_timer_finished:
			$EngineSound.stream = load("res://Assets/Sound/Other/pump_full_power_good.mp3")
		else: $EngineSound.stream = load("res://Assets/Sound/Other/pump_full_power_bad.mp3")
		
		full_power = value
		GameController.pump1_running = full_power
		if full_power:
			$Leak/Small.visible = true
			#$WorkingAtFullPowerTimer.start()
			$EngineSound.play()
			
			%RoomController.set_vibration_value("1.2")
			
			#$TimeToWinScreen.start()
		else: 
			$Leak/Small.visible = false
			
			$WorkingAtFullPowerTimer.stop()
			
			$Leak/LeakSound.stop()
			$EngineSound.stop()
			$EngineMetalSound.stop()
			$PodhipnikRattle.stop()
		
			%RoomController.set_vibration_value("0.0")
			
			#$TimeToWinScreen.stop()
	get: return(full_power)
		
var range_y = 0.015
var range_z = 0.025

var err6_repair_complete: bool = false

var flange_clicked: bool = false
var flange_transparent: bool = false:
	get: return flange_transparent
	set(value):
		flange_transparent = value
		$Motor/vs_flanec/StaticBody3D.set_collision_layer_value(2, flange_transparent)
		$Motor/podshipnik/StaticBody3D.set_collision_layer_value(2, !flange_transparent)
		# Обводка
		$Motor/vs_flanec.mesh.surface_get_material(0).\
			next_pass.set_shader_parameter("enable", flange_transparent)

var podshipnik_heat_clicked: bool = false
var podshipnik_heat: bool = false:
	get: return podshipnik_heat
	set(value):
		podshipnik_heat = value
		$Motor/podshipnik/StaticBody3D.set_collision_layer_value(2, podshipnik_heat)
		# Обводка
		$Motor/podshipnik.mesh.surface_get_material(0).\
			next_pass.next_pass.set_shader_parameter("enable", podshipnik_heat)
		# Эффект горячего воздуха
		$Motor/podshipnik.mesh.surface_get_material(0).\
			next_pass.set_shader_parameter("enable", podshipnik_heat)
			
		if podshipnik_heat: %Character.set_pirometr_value(70)
		else: %Character.set_pirometr_value(45)

var leak_detected: bool = false


func leak_medium() -> void:
	$Leak/LeakSound.volume_db = -22
	if not $Leak/LeakSound.playing: $Leak/LeakSound.play()
	
	$Leak/Small.visible = false
	$Leak/Medium.visible = true
	$Leak/Big.visible = false
	$Leak/Large.visible = false
	
func leak_big() -> void:
	$Leak/LeakSound.volume_db = -12
	if not $Leak/LeakSound.playing: $Leak/LeakSound.play()
	
	$Leak/Small.visible = false
	$Leak/Medium.visible = false
	$Leak/Big.visible = true
	$Leak/Large.visible = false
	
func leak_large() -> void:
	$Leak/LeakSound.volume_db = -10
	if not $Leak/LeakSound.playing: $Leak/LeakSound.play()
	
	$Leak/Small.visible = false
	$Leak/Medium.visible = false
	$Leak/Big.visible = false
	$Leak/Large.visible = true

func _on_leak_detector_leak_detected() -> void:
	leak_detected = true

# Для LossScreen, RetryScreen, WinScreen
func _on_end_screen_show() -> void:
	full_power = false
	set_defaults()

func _ready() -> void:
	LossScreen.loss_screen_show.connect(_on_end_screen_show)
	RetryScreen.retry_screen_show.connect(_on_end_screen_show)
	WinScreen.win_screen_show.connect(_on_end_screen_show)
	
	flange_transparent = false
	podshipnik_heat = false
	
	$Motor/vs_flanec.mesh.surface_get_material(0).proximity_fade_enabled = false
	$Motor/podshipnik/StaticBody3D.set_collision_layer_value(2, true)
	
	#$Motor/vs_flanec.mesh.surface_get_material(0).proximity_fade_enabled = false
	#$Motor/podshipnik.mesh.surface_get_material(0).\
			#next_pass.set_shader_parameter("enable", false)
	#repair_logos = true
	#flange_transparent = true
	#podshipnik_heat = true
	#$Motor/vs_flanec.mesh.surface_get_material(0).proximity_fade_distance = 4


func focused(is_focused: bool):
	#if not flange_transparent and full_power:
		#$Motor/podshipnik/VibrationDevice.visible = is_focused
	
	if flange_transparent:
		$Motor/vs_flanec.mesh.surface_get_material(0).next_pass.set_shader_parameter("enable", !is_focused)
		$Motor/vs_flanec.mesh.surface_get_material(0).proximity_fade_enabled = is_focused
	
	if podshipnik_heat:
		%Character.set_pirometr_value(80)
		
		# Обводка
		$Motor/podshipnik.mesh.surface_get_material(0).next_pass.next_pass.set_shader_parameter("enable", !is_focused)
		
		# Раньше мы тут кликали, но механику изменили, теперь просто надо взглянуть
		if not podshipnik_heat_clicked: podshipnik_heat_clicked = true
		
	if GameController.pump1_running:
		if not GameController.sensor_visible: 
			%Character.is_pirometr_visible = is_focused
		else: %Character.is_pirometr_visible = false


func on_click() -> void:
	pass
	if flange_transparent:
		if not GameController.sensor_visible:
			flange_clicked = true
	elif podshipnik_heat:
		if not GameController.sensor_visible:
			pass
			#podshipnik_heat_clicked = true
			#MessageController.show_message("", "Температура существенно выше нормы.")
	else:
		if not GameController.sensor_visible and full_power:
			pass
			#MessageController.show_message("", "Температура в норме.")



func set_defaults() -> void:
	range_y = 0.015
	range_z = 0.025
	#range_y = 0.03
	#range_z = 0.08
	$EngineSound.volume_db = -4
	$Leak/LeakSound.volume_db = 6
	$EngineSound.pitch_scale = 1
	
func set_pitch(value: float) -> void:
	$EngineSound.pitch_scale = value

func error4() -> void:
	range_y = 0.03
	range_z = 0.1
	$EngineSound.volume_db = 4
	
	
func error6() -> void:
	range_y = 0.04
	range_z = 0.11
	$EngineSound.volume_db = 6
	
func error7() -> void:
	range_y = 0.04
	range_z = 0.11
	$EngineSound.volume_db = 6
	
func error9() -> void:
	$EngineSound.volume_db = 4
	
func error10() -> void:
	leak_medium()
	$Leak/LeakDetector.enabled = true
	
	

func _on_repair_logo_repair_done() -> void:
	err6_repair_complete =  repair_logo_1_node.new_texture_set \
						and repair_logo_2_node.new_texture_set \
						and repair_logo_3_node.new_texture_set \
						and repair_logo_4_node.new_texture_set


func _process(delta: float) -> void:
	#print(podshipnik_heat_clicked)
	# DEBUG
	#if Input.is_action_just_pressed("space"):
		#full_power = true
		#await get_tree().create_timer(2).timeout
		#await RBCM_GameClient.find_node("%RoomController").wait(2)
		#error6()
	
	
	if full_power:
		transform.origin.y = clamp(
			transform.origin.y + randf_range(-range_y, range_y), 
			orig_transform.y - range_y * delta, 
			orig_transform.y + range_y * delta
		)
			
		transform.origin.z = clamp(
			transform.origin.z + randf_range(-range_z, range_z), 
			orig_transform.z - range_z * delta, 
			orig_transform.z + range_z * delta
		)

func _on_audio_stream_player_3d_finished() -> void:
	$EngineSound.play()


func _on_time_to_win_screen_timeout() -> void:
	WinScreen.show()


func _on_working_at_full_power_timer_timeout() -> void:
	working_less_min = false
	$EngineMetalSound.play()

func _on_engine_metal_sound_finished() -> void:
	$EngineMetalSound.play()

func _on_leak_sound_finished() -> void:
	$Leak/LeakSound.play()





func _on_podhipnik_rattle_finished() -> void:
	$PodhipnikRattle.play()
