extends CPUParticles3D

func _on_visibility_changed() -> void:
	if visible:
		$AudioStreamPlayer3D.play()
	else: $AudioStreamPlayer3D.stop()


func _on_audio_stream_player_3d_finished() -> void:
	$AudioStreamPlayer3D.play()
	$AudioStreamPlayer3D.seek(1.1)
