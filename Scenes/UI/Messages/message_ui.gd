extends Control

## Переходить к следующему сообщению, когда закончила звучать аудио-дорожка
@export var auto_skip_on_audio_end : bool = false
## Кол-во секунд во время которых нельзя закрыть сообщение
@export var non_skippable_sec : float = 1.0

# Разрешить скипать сообщения только спустя время таймера $TimeToSkipCutScene
var can_skip_cutscene : bool = false

func _ready() -> void:
	%NameCenterContainer.get_child(0).visible = true
	%MessageMarginContainer.get_child(0).visible = true
	
	$TimeToSkipCutScene.wait_time = non_skippable_sec
	$TimeToSkipCutScene.start()
	
	
func _process(_delta: float) -> void:
	# Когда сообщений больше не осталось - прекратить отображать сообщения
	if %MessageMarginContainer.get_child_count() == 0:
		queue_free()
	
	# Если под нодой с именами пустое имя, то скрыть плашку с именем	
	if %NameCenterContainer.get_child_count() !=0:
		if %NameCenterContainer.get_child(0).text == "": 
			$NameBG.visible = false
		else: $NameBG.visible = true


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("skip_cutscene") && can_skip_cutscene:
		_next_message()
		

func _next_message() -> void:
	# Считаем сколько всего сообщений предстоит показать
	var messages_queue = %MessageMarginContainer.get_child_count()
	
	# Ставим на очередь следющее сообщение
	if messages_queue > 1:
		%NameCenterContainer.get_child(1).visible = true
		%MessageMarginContainer.get_child(1).visible = true
		
	# Удаляем текущее сообщение
	%NameCenterContainer.get_child(0).queue_free()
	%MessageMarginContainer.get_child(0).queue_free()
	
	# Снова запускаем таймер для временной блокировки пропуска сообщений
	can_skip_cutscene = false
	$TimeToSkipCutScene.start()
	
func on_message_audio_finished():
	if auto_skip_on_audio_end:
		_next_message()

func _on_time_to_skip_cut_scene_timeout() -> void:
	can_skip_cutscene = true

func _on_tree_entered() -> void:
	GameController.is_cutscene = true

func _on_tree_exiting() -> void:
	GameController.is_cutscene = false
