extends Node3D
class_name phone

@export var enabled : bool = true:
	set(value):
		enabled = value
		_make_enabled(value)
	get: return(enabled)
	
	
# В состоянии true телефон звонит и внизу экрана отображается уведомление о звонке
@export var caption : String = "Телефон":
	get: return(caption)
	set(value):
		caption = value
		$Label3D.text = value

# В состоянии true телефон звонит и внизу экрана отображается уведомление о звонке
var is_ringing : bool = false:
	get: return(is_ringing)
	set(value):
		is_ringing = value
		
		#$CanvasLayer.visible = is_ringing
		if is_ringing: 
			$AudioStreamPlayer3D.play()
			
			# Когда телефон звонит - сделать его доступным
			enabled = true
		else: $AudioStreamPlayer3D.stop()

var clicked: bool = false


func on_click() -> void:
	is_ringing = false
	
	clicked = true
	
	# Дожидаемся начала диалога
	await GameController.cutscene_started
	clicked = false
	

func _make_enabled(value : bool):
	$phone/StaticBody3D.set_collision_layer_value(2, value)
	
func focused(is_focused : bool):
	$Label3D.visible = is_focused
	$phone.material_overlay.next_pass.set_shader_parameter("enable", is_focused)
		
func _on_audio_stream_player_3d_finished() -> void:
	if is_ringing:
		$AudioStreamPlayer3D.play()
