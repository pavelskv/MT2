extends Node

signal cutscene_started
signal cutscene_ended

var first_start_occured: bool = false
var console = JavaScriptBridge.get_interface("console")

var sensor_visible: bool = false
var briefing_visible: bool = false
var pump1_running: bool = false


var no_more_errors: bool = false
var switch_done: bool = false

#Действия, которые нужно выполнить после перезапуска уровня
var showTasks = false
	
	


var is_cutscene: bool = false:
	get: return is_cutscene
	set(value):
		is_cutscene = value
		
		if is_cutscene: cutscene_started.emit()
		else: cutscene_ended.emit()


var mouse_visible: bool = true:
	get: return mouse_visible
	set(value):
		mouse_visible = value
		
		if mouse_visible: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		


#func _ready() -> void:
	# DEBUG
	#console.log("DEBUG MESSAGE")
	
	
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
# Перезапуск уровня с учетом возможно активного RBCM мониторинга (его надо сбросить)
func restart_level(disable_errors: bool = false) -> void:
	if RBCM_GameClient.connected:
		RBCM_GameClient.client.disconnect_from_server()
	
	no_more_errors = disable_errors
	
	# Отключаем отслеживание сигналов окончания диалога для room_controller,
	# чтобы на рестарте не продолжились действия логики после await %RoomController.cutscene_ended,
	# функции которая теперь используется вместо await GameController.cutscene_ended
	RBCM_GameClient.find_node("%RoomController").disconnect_from_game_controller()
	
	get_tree().reload_current_scene()
	
	await get_tree().create_timer(1).timeout
	if RBCM_GameClient.is_sync_mode:
		RBCM_GameClient.client.connect_to_server()
		
