extends Node

const auto_generated_files_dir = "res://Assets/Sound/Voice/Generated/"

# Главная сцена для сообщений
var message_ui

# Предзагрузка элементов для отображения сообщений
var message_container_scene: PackedScene = preload("res://Scenes/UI/Messages/message_ui.tscn")
var name_scene: PackedScene = preload("res://Scenes/UI/Messages/name_container.tscn")
var message_scene: PackedScene = preload("res://Scenes/UI/Messages/message_container.tscn")


func _ready() -> void:
	# Останавливать любые сообщения при изменени is_cutscene в GameController
	GameController.cutscene_ended.connect(stop_messages)

func stop_messages() -> void:
	# Остановить отображение любых сообщений
	if is_instance_valid(message_ui):
		message_ui.queue_free()


func show_message(speaker_name: String, speaker_text: String, sound: String = ""):
	# Если предыдущей сцены еще нет или она "отыграла своё" и была закрыта, то надо создать новую
	var is_new_diaglog = false
	if !is_instance_valid(message_ui):
		message_ui = message_container_scene.instantiate()
		is_new_diaglog = true
	
	var name_container = name_scene.instantiate()
	var message_container = message_scene.instantiate()
		
	if sound.is_empty():
		var audio_file = find_audio(speaker_name, speaker_text)
		if not audio_file.is_empty():
			message_container.get_node("MesssageAudio").stream = load(audio_file)
		else:
			message_container.get_node("MesssageAudio").stream = load("res://Assets/Sound/Voice/empty.mp3")
	else:
		message_container.get_node("MesssageAudio").stream = load(sound)

	name_container.text = speaker_name
	message_container.text = speaker_text.replace("+", "") # Избавляемся от потенциальных ударений озвучки в тексте


	message_ui.get_node("NameBG/NameCenterContainer").add_child(name_container)
	message_ui.get_node("MessageBG/MessageMarginContainer").add_child(message_container)
	
	if is_new_diaglog:	
		add_child(message_ui)



func find_audio(speaker_name : String, speaker_text : String) -> String:
	for voice in RBVG_VoiceGenerator.avaliable_voices:
		var file = (speaker_name + speaker_text.replace("\t", "") + voice).sha1_text() + ".mp3"
		if ResourceLoader.exists(auto_generated_files_dir + file):
			return auto_generated_files_dir + file

	return String()
