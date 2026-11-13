extends RichTextLabel

func _on_visibility_changed() -> void:
	if visible:
		$MesssageAudio.play()

func _on_messsage_audio_finished() -> void:
	var message_ui_node = get_node("../../../")
	message_ui_node.on_message_audio_finished()
