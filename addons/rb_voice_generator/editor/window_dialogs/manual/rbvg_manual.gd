@tool
extends RBVG_VoiceGenerator

const manual_generated_files_dir := "res://Assets/Sound/Voice/Manual/"


func _ready() -> void:
	log = %LogRichTextLabel
	
func on_show() -> void:
	%TextToVoiceEdit.clear()
	log_clear()
	

func _on_start_button_pressed() -> void:
	if %TextToVoiceEdit.text.dedent().is_empty():
		MessageBox("Ошибка: не указан текст для озвучки")
		return
	
	if DirAccess.dir_exists_absolute(manual_generated_files_dir):
		%SaveFileDialog.root_subfolder = manual_generated_files_dir
		
	%SaveFileDialog.popup()




func _on_save_file_dialog_file_selected(path: String) -> void:
	var voice = %ManualVoiceSelector.get_selected_voice_code()
	var text = %TextToVoiceEdit.text

	log_clear()
	log_append(rbvg_bb.aqua("Начало обработки"))
	
	await update_token()
	var response = await generate_audio(voice, text)
	
	if not response.is_empty():
		var file = FileAccess.open(path + ".tmp", FileAccess.WRITE)
		file.store_buffer(response)
		file.close()
	
		convert_mp3(path + ".tmp", path)
		
		log_append("Аудиофайл " + rbvg_bb.green("сохранен"))
	else:
		log_append("%s во время получения файла" % rbvg_bb.orange("Ошибка"))
		
	log_append(rbvg_bb.aqua("Обработка завершена"))
	
	
