extends MeshInstance3D
class_name leak

signal leak_detected

var timer_started: bool = false

@export var enabled: bool = false:
	get: return enabled
	set(value):
		enabled = value
		$StaticBody3D.set_collision_layer_value(2, enabled)

func focused(_is_focused: bool):
	if not timer_started:
		timer_started = true
		$AudioStreamPlayer.play()
		$Timer.start()
	


func _on_timer_timeout() -> void:
	$Warning.visible = true
	#await RBCM_GameClient.find_node("%RoomController").wait(1)
	await get_tree().create_timer(1).timeout
	$Warning.visible = false
	
	leak_detected.emit()
