extends Node

signal speedy_timer_finished

##  Сколько минут показывать на счетчике
@export var minutes: int = 30
var init_minutes: int


## За сколько секунд таймер дойдет от [Minutes] минут до нуля
@export var total_seconds: float = 60


# DEBUG 
#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("zero"):
		#start()


func _ready() -> void:
	init_minutes = minutes
	%Timer_count.text = str(minutes) + " мин"

func start() -> void:
	if $Timer.is_stopped():
		minutes = init_minutes
		$Timer.wait_time = total_seconds / minutes
		
		%Timer_count.text = str(minutes) + " мин"
		

		$Timer_UI.visible = true
		
		$Timer.start()
		
func stop() -> void:
	if not $Timer.is_stopped():
		$Timer_UI.visible = false
		$Timer.stop()

func _on_timer_timeout() -> void:
	if minutes == 0:
		$Timer.stop()
		speedy_timer_finished.emit()
		$Timer_UI.visible = false
	else:
		minutes -= 1
		%Timer_count.text = str(minutes) + " мин"

