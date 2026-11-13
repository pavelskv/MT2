@tool
extends Node

func get_selected_voice_code() -> String:
	#var selected_voice = %VoicesList.get_item_text(%VoicesList.selected)
	return RBVG_VoiceGenerator.avaliable_voices[%VoicesList.text]

func populate_voices():
	%VoicesList.clear()
	for voice in RBVG_VoiceGenerator.avaliable_voices:
		%VoicesList.add_item(voice)

	%VoicesList.selected = 0

func enable_voice_selection() -> void:
	%VoicesList.disabled = false
	
func disable_voice_selection() -> void:
	%VoicesList.disabled = true


func _ready() -> void:
	populate_voices()

