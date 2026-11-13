extends Node

# Signals
signal cutscene_ended
signal cutscene_started

# Easy access list
@onready var WaitForAirGoneBy_TimeRemain = $WaitForAirGoneByTimer/WaitForAirGoneBy_UI/ColorRect/Timer_count
@onready var WaitForAirGoneBy_UI = $WaitForAirGoneByTimer/WaitForAirGoneBy_UI

@onready var GoodCallTimer_TimeRemain = $GoodCallTimer/GoodCallTimer_UI/ColorRect/Timer_count
@onready var GoodCallTimer_UI = $GoodCallTimer/GoodCallTimer_UI

@onready var FinalTimer_TimeRemain = $FinalTimer/FinalTimer_UI/ColorRect/Timer_count
@onready var FinalTimer_UI: MarginContainer = $FinalTimer/FinalTimer_UI

#@export_category("Ошибки")
#@export var error6: bool = false
#@export var error7: bool = false
#@export var error8: bool = false
#@export var error9: bool = false
#@export var error10: bool = false

var error4: bool = false
var error6: bool = false
var error7: bool = false
var error8: bool = false
var error9: bool = false
var error10: bool = false

var to_other_systems_closed: bool
var to_consumer_systems_closed: bool

var air_gone_by_timer_finished: bool = false

var timer30min_finished: bool = false
var one_minute_timer_finished: bool = false

var final_timer_finished: bool = false

var cutscene_err7_finished: bool = false

var error6_active: bool = false

func _on_timer_30_min_speedy_timer_finished() -> void:
	timer30min_finished = true

func start_30min_timer() -> void:
	timer30min_finished = false
	$Timer30min.start()
	
func stop_30min_timer() -> void:
	#timer30min_finished = true
	$Timer30min.stop()
	
# Повтор фоновых звуков
func _on_ambience_finished() -> void:
	$Ambience.play()
	
func set_vibration_value(new_value: String) -> void:
	#%Pump1/Motor/podshipnik/VibrationDevice.value = new_value
	#%Podshipnik2/VibrationDevice.value = new_value
	#%Podshipnik3/VibrationDevice.value = new_value
	%vibro.value = new_value
	
func start_one_minute_timer() -> void:
	#print("one minute STARTED")
	one_minute_timer_finished = false
	$TimerOneMinute.start()

func stop_one_minute_timer() -> void:
	#print("one minute STOPED")
	$TimerOneMinute.stop()
	
func _on_timer_one_minute_timeout() -> void:
	if error4:
		#%Pump1/PodhipnikRattle.play()
		#await wait(1)
		%Pump1.full_power = false
		
		%Pump1.set_defaults()
		%Phone.enabled = false
		MessageController.stop_messages()
		MessageController.show_message("", "По причине недостаточного воздухоудаления и длительной работы насоса в режиме кавитации произошла поломка рабочего колеса. Работник НО и ВИУР от работы отстранены с пересдачей экзамена по ОПЭ АС.", "res://Assets/Sound/Voice/Manual/error4_after_one_minute_fail.mp3")

		one_minute_timer_finished = true
		await cutscene_ended
		LossScreen.show()
		
	if error6:
		%RoomController.stop_30min_timer()
		
		%Pump1/PodhipnikRattle.play()
		await wait(1)
		%Pump1.full_power = false
		
		%Pump1.set_defaults()
		%Phone.enabled = false
		MessageController.stop_messages()
		MessageController.show_message("", "За недостаточный контроль за работой НА (длительную работу с недопустимо высокой вибрацией, в результате которой НА вышел из строя), инженер НО и ВИУР от работы отстранены с пересдачей экзамена по ОПЭ АС.", "res://Assets/Sound/Voice/Manual/error6_after_one_minute_fail.mp3")
		#В результате работы с недопустимо высокой вибрацией ЭН, А - вышел из строя. Работник ЭН,О - от работы отстранен и отправлен на пересдачу экзамена по ОПЭ А ЭС.
		
		one_minute_timer_finished = true
		await cutscene_ended
		LossScreen.show()
	
	if error7:
		%RoomController.stop_30min_timer()
		
		%Pump1/PodhipnikRattle.play()
		await wait(1)
		%Pump1.full_power = false
		
		%Pump1.set_defaults()
		%Phone.enabled = false
		MessageController.stop_messages()
		MessageController.show_message("", "В результате длительной работы насоса в режиме кавитации произошла поломка рабочего колеса. За недостаточный контроль за работой НА инженер НО и ВИУР от работы отстранены с пересдачей экзамена по ОПЭ АС.", "res://Assets/Sound/Voice/Manual/error7_after_one_minute_fail.mp3")
		
		one_minute_timer_finished = true
		await cutscene_ended
		LossScreen.show()
		
	if error9:
		%RoomController.stop_30min_timer()
		%Pump1.full_power = false
		%Pump1.set_defaults()
		%Pump1/RepairLogo.visible = true
		#%Phone.enabled = false
		MessageController.stop_messages()
		MessageController.show_message("", "Насос отключился защитой по повышению температуры подшипника до 80°С.", "res://Assets/Sound/Voice/Manual/error9_after_one_minute_fail.mp3")
		
		
		one_minute_timer_finished = true
		#await cutscene_ended
		#LossScreen.show()
		
	one_minute_timer_finished = true
		

func connect_to_game_controller() -> void:
	GameController.cutscene_started.connect(cutscene_started_check)
	GameController.cutscene_ended.connect(cutscene_ended_check)
	
func disconnect_from_game_controller() -> void:
	GameController.cutscene_started.disconnect(cutscene_started_check)
	GameController.cutscene_ended.disconnect(cutscene_ended_check)

func cutscene_ended_check() -> void:
	cutscene_ended.emit()
	
func cutscene_started_check() -> void:
	cutscene_started.emit()
	
	
func _ready() -> void:
	# Подключение сигналов
	connect_to_game_controller()
	
	$TimerOneMinute.wait_time = $Timer30min.total_seconds + 0.5
	
	# Постоянное давление в 0.17МПа перед напором
	%TankFlowSensor.set_pressure_017()
	
	# Случайный поворот вентилей на старте уровня
	# Добавьте желаемые для случайного поворота вентили в группу "random_vents"
	var random_vents = get_tree().get_nodes_in_group("random_vents")
	for vent in random_vents:
		vent.is_opened = randi_range(0, 1)
	
	# Случайным образом определяем, будет ли сломан вентиль (4.1)
	#%Pump2Valve1.broken = true    #randi_range(0, 1)
	
	#GameController.error4_occured = false
	error4 = false
	error6 = false
	error7 = false
	error8 = false
	error9 = false
	error10 = false
		
	# Определяем случайные ошибки
	if not GameController.no_more_errors:
		var _random_err_number = randi_range(6, 10)
		# УБРАТЬ ДЛЯ СЛУЧАЙНЫХ ОШИБОК
		#match random_err_number:
			#6: error6 = true
			#7: error7 = true
			#8: error8 = true
			#9: error9 = true
			#10: error10 = true
	#else:
		##GameController.error4_occured = false
		#error4 = false
		#error6 = false
		#error7 = false
		#error8 = false
		#error9 = false
		#error10 = false
	
	to_other_systems_closed = to_other_systems_closed_check()
	to_consumer_systems_closed = to_consumer_systems_closed_check()



func _process(_delta: float) -> void:
	# Показывать таймер завоздушины, когда он активен
	if $WaitForAirGoneByTimer.time_left > 0:
		WaitForAirGoneBy_TimeRemain.text = str(round($WaitForAirGoneByTimer.time_left))
		
	# Показывать таймер запуска насоса, когда он активен
	if $GoodCallTimer.time_left > 0:
		GoodCallTimer_TimeRemain.text = str(round($GoodCallTimer.time_left))
		
	# Показывать таймер выбега вала, когда он активен
	if $FinalTimer.time_left > 0:
		FinalTimer_TimeRemain.text = str(round($FinalTimer.wait_time - $FinalTimer.time_left))
		
		if not %Pump1/EngineSoundFinal.playing:
			%Pump1/EngineSoundFinal.play()
	elif %Pump1/EngineSoundFinal.playing:
		%Pump1/EngineSoundFinal.stop()



func _on_good_call_timer_timeout() -> void:
	# Все выполнено успешно, выключаем отображение времени до запуска
	GoodCallTimer_UI.visible = false
	
	# Включаем насос
	%Pump1.full_power = true
	

func _on_final_timer_timeout() -> void:
	FinalTimer_UI.visible = false
	final_timer_finished = true


func _on_to_other_systems_has_rotated(_is_opened: bool) -> void:
	to_other_systems_closed = to_other_systems_closed_check()
	
func _on_to_consumer_systems_has_rotated(_is_opened: bool) -> void:
	to_consumer_systems_closed = to_consumer_systems_closed_check()


func _on_poster_tree_exiting() -> void:
	# Сделать доступным вентиль бака, после снятия постера
	%StarterVent.enabled = true

func to_other_systems_closed_check() -> bool:
	if !%ToOtherSystems1.is_opened && !%ToOtherSystems2.is_opened && \
		!%ToOtherSystems3.is_opened:
			return true
	else: return false
	
func to_consumer_systems_closed_check() -> bool:
	if !%ToConsumerSystems1.is_opened && !%ToConsumerSystems2.is_opened && \
		!%ToConsumerSystems3.is_opened && !%ToConsumerSystems4.is_opened:
			return true
	else: return false

func _on_wait_for_air_gone_by_timer_timeout() -> void:
	# По окончании минуты выключаем таймер
	WaitForAirGoneBy_UI.visible = false
	
	air_gone_by_timer_finished = true


# Замена прошлому подходу с await get_tree().create_timer(5).timeout,
# т.к. на перезапуске уровня корутины остаются и спустя время продолжают
# выполнять код, который был актуален ДО перезагрузки
func wait(sec: float) -> void:
	var timer = Timer.new()
	timer.one_shot = true 
	add_child(timer)
	timer.start(sec)
	await timer.timeout
	timer.queue_free()
	












