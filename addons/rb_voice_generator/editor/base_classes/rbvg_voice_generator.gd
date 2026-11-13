# БАЗОВЫЙ КЛАСС С НАБОРОМ ВСЕХ ФУНКЦИЙ

@tool
class_name RBVG_VoiceGenerator extends Node

var log: RichTextLabel

var ffmpeg := ProjectSettings.globalize_path("res://addons/rb_voice_generator/editor/utils/") \
			+ "ffmpeg.exe"
			
var ffmpeg_mac := ProjectSettings.globalize_path("res://addons/rb_voice_generator/editor/utils/") \
			+ "ffmpeg"

var trusted_ca_file := preload("res://addons/rb_voice_generator/editor/ca/SaluteSpeech Root CA.crt")

var get_token_base_url := "https://ngw.devices.sberbank.ru"
var get_token_request_url := "/api/v2/oauth"
var get_token_port = 9443


var api_base_url := "https://smartspeech.sber.ru"
var api_request_url := "/rest/v1/text:synthesize"
var api_port := 443


var clientID := "Njg4ODJhMzUtYmE0Yi00NmRmLTg3YTQtZDM0MmRkZjc1M2E5OjI3NmYwNTQxLWVjY2ItNGUwNi04MmI4LTMzMDFiMTI2ZWJmMQ=="
var token: String

const avaliable_voices = {
	"Борис" = "Bys_24000",
	"Тарас" = "Tur_24000",
	"Сергей" = "Pon_24000",
	
	"Наталья" = "Nec_24000",
	"Марфа" = "May_24000",
	"Александра" = "Ost_24000"
}


func log_clear() -> void:
	log_append("Очистка логов")
	log.clear()

func log_append(msg) -> void:
	var system_time = Time.get_time_dict_from_system()
	var time = "[[color=yellow]%02d:%02d:%02d[/color]] " % \
				[system_time.hour, system_time.minute, system_time.second]
	log.append_text(time + str(msg) + "\n")

func MessageBox(msg: String) -> void:
	var dialog = AcceptDialog.new()
	dialog.unresizable = true
	dialog.dialog_text = msg
	dialog.title = "RB Voice Generator"
	dialog.connect("confirmed", func() -> void:
		dialog.queue_free()
	)
	dialog.connect("canceled", func() -> void:
		dialog.queue_free()
	)
	add_child(dialog)
	dialog.popup_centered()
	dialog.grab_focus()
	

func convert_mp3(old_filename: String, new_filename: String) -> void:
	log_append("Обработка файла %s" % rbvg_bb.orange(new_filename.get_file()))
	
	old_filename = ProjectSettings.globalize_path(old_filename)
	new_filename = ProjectSettings.globalize_path(new_filename)
	OS.execute(ffmpeg_mac, ["-y", "-i", old_filename, "-q", "1", "-map", "a", new_filename])
	DirAccess.remove_absolute(old_filename)
	
	log_append("Обработка файла завершена")

func update_token() -> void:
	var err = 0
	var api = HTTPClient.new()
	var tls_options = TLSOptions.client(trusted_ca_file)
	
	log_append("Получение %s доступа..." % rbvg_bb.spgr("токена"))
	err = api.connect_to_host(get_token_base_url, get_token_port, tls_options)
	assert(err == OK)


	# Ждем пока адрес срезолвится и мы начнем подключаться
	while api.get_status() == HTTPClient.STATUS_CONNECTING or api.get_status() == HTTPClient.STATUS_RESOLVING:
		api.poll()
		await get_tree().process_frame

	# Убедимся, что соединение установлено
	assert(api.get_status() == HTTPClient.STATUS_CONNECTED) 


	# Обязательные заголовки запроса и само тело запроса
	var headers = [
		"Authorization: Basic %s" % clientID,
		"RqUID: %s" % uuid.generate(),
		"Content-Type: application/x-www-form-urlencoded"
	]
	var body = api.query_string_from_dict({"scope" : "SALUTE_SPEECH_PERS"})

	err = api.request(HTTPClient.METHOD_POST, get_token_request_url, headers, body)
	assert(err == OK) 

	while api.get_status() == HTTPClient.STATUS_REQUESTING:
		api.poll()
		await get_tree().process_frame

	# Убеждаемся, что запрос завершился успешно
	assert(api.get_status() == HTTPClient.STATUS_BODY or api.get_status() == HTTPClient.STATUS_CONNECTED) 

	# Обработка ответа
	if api.has_response():
		# Массив для хранения данных ответа
		var rb = PackedByteArray() 

		# Выкачиваем все данные ответа
		while api.get_status() == HTTPClient.STATUS_BODY:
			api.poll()
			
			var chunk = api.read_response_body_chunk()
			if chunk.size() == 0:
				await get_tree().process_frame
			else:
				rb = rb + chunk
		
		# Done!
		log_append("Токен доступа %s" % rbvg_bb.spgr("получен"))
		
		var json_response = rb.get_string_from_ascii()
		var response = JSON.parse_string(json_response)
		token = response["access_token"]


func parse_text(text: String) -> String:
	# Преобразует числа в слова для озвучки (5.2 кг/с; 0,5 кг\с; etc => 5 и 2; 0 и 5; etc)
	#text = text.replacen("кг/с", "").replacen("кг\\с", "")
	
	# Преобразует числа в слова для озвучки (5.2 МПа; 0,5 МПа; etc => 5 и 2; 0 и 5; etc)
	text = text.to_lower().replace("мпа", "эмпэa'")
	
	# Преобразует числа в слова для озвучки (5.2 МПа; 0,5 МПа; etc => 5 и 2; 0 и 5; etc)
	text = text.to_lower().replace("л/с", "литра в секунду")
	text = text.to_lower().replace("кг/с", "килограмм в секунду")
	
	text = text.to_lower().replace("ДЭС ЦТАИ".to_lower(), "дэс цэта'и")
	
	# Озвучка кодов оборудования
	text = text.to_lower().replace("РНХ".to_lower(), "ЭРЭНХА'")
	text = text.to_lower().replace("ТАИ".to_lower(), "ТА'И")
	text = text.to_lower().replace("10КВС22АР001".to_lower(), "десять кэбэцэ' двадцать два апэ' ноль ноль один")
	text = text.to_lower().replace("10КВС24АА201".to_lower(), "десять кэбэцэ' двадцать четыре аа' двести один")
	text = text.to_lower().replace("10КВС22АА002".to_lower(), "десять кэбэцэ' двадцать два аа' ноль ноль два")
	text = text.to_lower().replace("10КВС21АР001".to_lower(), "десять кэбэцэ' двадцать один апэ' ноль ноль один")
	
	
	
	# Прочий фикс ударений
	text = text.to_lower().replace(" вала ".to_lower(), " ва'ла ")
	
	#var regex = RegEx.create_from_string(r'\d+[.,]\d+')
#
	#for result in regex.search_all(text):
		#var finded_text = result.get_string() 
		#var replaced = finded_text.replace(",", " и ").replace(".", " и ")
		#text = text.replace(finded_text, replaced)
	
	return text
	

func generate_audio(voice: String, text: String) -> PackedByteArray:
	text = parse_text(text)

	var err = 0
	var api = HTTPClient.new()
	var tls_options = TLSOptions.client(trusted_ca_file)
	
	log_append("Генерация аудио...")
	err = api.connect_to_host(api_base_url, api_port, tls_options)
	assert(err == OK)


	# Ждем пока адрес срезолвится и мы начнем подключаться
	while api.get_status() == HTTPClient.STATUS_CONNECTING or api.get_status() == HTTPClient.STATUS_RESOLVING:
		api.poll()
		await get_tree().process_frame

	# Убедимся, что соединение установлено
	assert(api.get_status() == HTTPClient.STATUS_CONNECTED) 


	# Обязательные заголовки запроса и само тело запроса
	var headers = [
		"Authorization: Bearer %s" % token,
		"Content-Type: application/text"
	]
	var body = text

	err = api.request(	HTTPClient.METHOD_POST, 
						api_request_url + "?format=opus&voice=" + voice, 
						headers, 
						body)
	assert(err == OK) 

	while api.get_status() == HTTPClient.STATUS_REQUESTING:
		api.poll()
		await get_tree().process_frame

	# Убеждаемся, что запрос завершился успешно
	assert(api.get_status() == HTTPClient.STATUS_BODY or api.get_status() == HTTPClient.STATUS_CONNECTED) 

	# Обработка ответа
	if api.has_response():
		# Массив для хранения данных ответа
		var rb = PackedByteArray() 

		# Выкачиваем все данные ответа
		while api.get_status() == HTTPClient.STATUS_BODY:
			api.poll()
			
			var chunk = api.read_response_body_chunk()
			if chunk.size() == 0:
				await get_tree().process_frame
			else:
				rb = rb + chunk
		
		# Done!
		log_append("Генерация завершена")
		return rb
	
	return PackedByteArray()
	
	
	
	
	
	
	
