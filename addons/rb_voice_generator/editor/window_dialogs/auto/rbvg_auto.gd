@tool
extends RBVG_VoiceGenerator

const auto_generated_files_dir = "res://Assets/Sound/Voice/Generated/"

var auto_voice_selector = preload("res://addons/rb_voice_generator/editor/window_dialogs/_components/auto_voice_selector.tscn")

var messages = []
var unique_voices = []


func _ready() -> void:
	# Иконки для кнопок управления
	%UpdateVoicesListButton.icon = EditorInterface.get_editor_theme().get_icon("Reload", "EditorIcons")
	
	# Явное указание на то, где у нас расположен элемент для логов
	log = %LogRichTextLabel


func on_show() -> void:
	populate_names_voices()


# Ищет файлы с указанными расширениями (по желанию с вложенными директориями)
func find_files(directory: String, recursive: bool, extensions_to_search: Array) -> Array:
	var files = []
	
	var dir = DirAccess.open(directory)
	assert(dir, "Директория %s недоступна" % directory)
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while not file_name.is_empty():
		if file_name.begins_with("."):
			file_name = dir.get_next()
			continue
		if dir.current_is_dir():
			if (directory + file_name) == "res://addons":
				file_name = dir.get_next()
				continue
			else: 
				if recursive:
					files += find_files(directory + file_name + "/", recursive, extensions_to_search)
		else:
			var file_extension = file_name.get_extension()
			if file_extension in extensions_to_search:
				files.append(directory + file_name)

		file_name = dir.get_next()
	
	dir.list_dir_end()
	return files


# Поиск сообщений (MessageController.show_message) в тексте
func regex_search(text: String) -> Array:
	var results = []
	
	##var regex_pattern = r'MessageController\.show_message\(\s*"([^"]+)"\s*,\s*"([^"]+)"\s*\)'
	##var regex_pattern = r'MessageController\.show_message\(\s*"(.*?)"\s*,\s*"([^"]+)"\s*\)'
	var regex_pattern = r'MessageController\.show_message\(\s*"([^"]*?)"\s*,\s*"([^"]+)"\s*\)'

	
	var regex := RegEx.create_from_string(regex_pattern)

	var regex_matches = regex.search_all(text)
	for regex_match in regex_matches:
		var arg1 = regex_match.get_string(1)	# имя говорящего
		var arg2 = regex_match.get_string(2)	# текст
		
		# Добавлять только уникальные фразы (имя+текст)
		var result = {speaker_name = arg1, speaker_text = arg2, hash = "", voice_code = ""}
		if not results.has(result):
			results.append(result)
			
	return results


# Читает содержимое файла и ищет сообщения через ф-ю regex_search
func parse_messages(file_path: String) -> Array:
	var messages = []

	var File = FileAccess.open(file_path, FileAccess.READ)
	
	if file_path.ends_with(".rbcm"):
		while File.get_position() < File.get_length():
			var line = File.get_line()
			var data = JSON.parse_string(line)
			
			if not data.code.on_active.is_empty():
				messages.append_array(regex_search(data.code.on_active))
				
			if not data.code.on_completed.is_empty():
				messages.append_array(regex_search(data.code.on_completed))


	if file_path.ends_with(".gd"):
		var file_text = File.get_as_text()
		messages.append_array(regex_search(file_text))
		
	File.close()
	return messages


# Получает данные об уникальных голосах и всех уникальных сообщениях
# Сохраняет результаты в глобальные массивы unique_voices и messages
func populate_names_voices() -> void:
	log_clear()
	
	%ProgressBar.value = 0
	%NoVoicesoundLabel.visible = false

	var extensions_to_search = ["gd", "rbcm"]
	var files = find_files("res://", true, extensions_to_search)
	
	# Предварительная очистка
	if get_tree().get_nodes_in_group("auto_selector_group"):
		get_tree().call_group("auto_selector_group", "queue_free")
		while get_tree().get_nodes_in_group("auto_selector_group"):
			# Ждем, пока удалятся ноды
			await Engine.get_main_loop().process_frame
	messages.clear()
	unique_voices.clear()
	
	log_append("Поиск имен и диалогов...")
	# Собираем все фразы для озвучки
	for file in files:
		var results = parse_messages(file)
		for result in results:
			if not messages.has(result):
				messages.append(result)
	
	# Собираем уникальные голоса и добавляем по меню на каждый голос
	for message in messages:
		if not unique_voices.has(message.speaker_name):
			unique_voices.append(message.speaker_name)
			
			var _auto_selector = auto_voice_selector.instantiate()
			_auto_selector.get_node("%NameData").text = message.speaker_name
			_auto_selector.add_to_group("auto_selector_group")
			%NameVoiceContainer.add_child(_auto_selector)

	# Если голосов не нашлось, то включить предупреждающее сообщение и кнопку обновления
	if unique_voices.is_empty(): %NoVoicesoundLabel.visible = true

	log_append("Поиск завершен")


# Проходит по массиву сообщений (messages) и делает ему нужные хэш (sha1)
# в зависимости от выбранного голоса для каждого спикера
func update_messages_hash_and_voice_code() -> void:
	var auto_selector_nodes = get_tree().get_nodes_in_group("auto_selector_group")
	var auto_selectors_map = []
	
	# Если хоть что-то было найдено
	if auto_selector_nodes:
		
		for auto_selector in auto_selector_nodes:
			auto_selectors_map.append(
				{
					speaker_name = auto_selector.get_node("%NameData").text,
					speaker_voice = auto_selector.get_node("%VoicesList").text
				}
			)
		
		for auto_selector in auto_selectors_map:
			for message in messages:
				if message.speaker_name == auto_selector.speaker_name:
					# Хэш из имени говорящего, его текста и голоса из списка (это будет именем файла + .mp3)
					message.hash = (message.speaker_name + message.speaker_text + auto_selector.speaker_voice).sha1_text()
					message.voice_code = RBVG_VoiceGenerator.avaliable_voices[auto_selector.speaker_voice]



# Очищает папку auto_generated_files_dir от старых записей и
# возвращает список будущих файлов, из которого убраны дубликаты озвучки
func cleanup_and_get_files_to_create() -> Array:
	log_append("Подготовка директории выгрузки...")
	
	var extensions_to_search = ["mp3", "import", "tmp"]
	var files = find_files(auto_generated_files_dir, false, extensions_to_search)
	var mp3_and_import_files = []
	
	# Избавимся от файлов .tmp, а из оставшихся файлов соберем массив с путями к .mp3 и .import файлам
	for file in files:
		if file.get_extension() == "tmp":
			DirAccess.remove_absolute(file)
		elif file.get_extension() in ["mp3", "import"]:
			mp3_and_import_files.append(file.get_file())
			
	# Сформируем будущие пути аудиофайлов на основе найденных сообщений
	var audio_files_to_create = []
	for message in messages:
		var file_name = message.hash + ".mp3"
		audio_files_to_create.append(file_name)


	# Вначале удалим все файлы, которых нет среди списка будущих файлов на озвучку
	# А те файлы, которые уже озвучены (есть в папке) - исключим из будущих файлов на озвучку
	for file in mp3_and_import_files:
		if file.get_extension() == "import": continue
		
		var mp3_file = auto_generated_files_dir + file
		var import_file = mp3_file + ".import"
		
		
		if file not in audio_files_to_create:
			DirAccess.remove_absolute(mp3_file)
			if FileAccess.file_exists(import_file):
				DirAccess.remove_absolute(import_file)
		else: 
			audio_files_to_create.erase(file)
			audio_files_to_create.erase(file + ".import")
			
	
	log_append("Подготовка завершена")
	
	return audio_files_to_create


func _on_start_button_pressed() -> void:
	if unique_voices.is_empty():
		log_append("%s: список голосов и реплик пуст" % rbvg_bb.orange("Ошибка"))
		return

	log_clear()
	
	log_append(rbvg_bb.aqua("Начало обработки"))
	get_tree().call_group("auto_selector_group", "disable_voice_selection")
	%StartButton.disabled = true
	%UpdateVoicesListButton.disabled = true
	
	# Выставим соответствующие хэши найденным сообщениям 
	# (на основе говорящего, текста и выбранного голоса)
	update_messages_hash_and_voice_code()
	
	# Подчистим папку с прошлыми (сгенерированными автоматически) звуками
	# и получим финальный список имен файлов, какими они будут на выходе.
	# Затем соберем из оригинального массива messages финальный массив для
	# итоговой озвучки - final_messages
	var audio_files_to_create = cleanup_and_get_files_to_create()
	var final_messages = []
	for message in messages:
		if message.hash + ".mp3" in audio_files_to_create:
			final_messages.append(message)
	
	%ProgressBar.value = 0
	%ProgressBar.max_value = final_messages.size()

	log_append("Уникальных голосовых реплик: %s" % rbvg_bb.orange(str(final_messages.size())))
	
	if final_messages.size() !=0:
		await update_token()
		
		var response
		for message in final_messages:
			response = await generate_audio(message.voice_code, message.speaker_text)
		
			if not response.is_empty():
				var tmp_filename = auto_generated_files_dir + message.hash + ".tmp"
				var final_filename = auto_generated_files_dir + message.hash + ".mp3"
				
				var file = FileAccess.open(tmp_filename, FileAccess.WRITE)
				file.store_buffer(response)
				file.close()
			
				convert_mp3(tmp_filename, final_filename)
				
				log_append("Аудиофайл сохранен")
			else:
				log_append("%s во время получения одного из файлов." % rbvg_bb.orange("Ошибка"))
				log_append(rbvg_bb.aqua("Конец обработки"))
				%ProgressBar.value = 0
				return
				
			%ProgressBar.value += 1

	log_append(rbvg_bb.aqua("Обработка завершена"))
	get_tree().call_group("auto_selector_group", "enable_voice_selection")
	%StartButton.disabled = false
	%UpdateVoicesListButton.disabled = false


func _on_update_voices_list_button_pressed() -> void:
	populate_names_voices()
	
	
