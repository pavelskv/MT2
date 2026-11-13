extends TextureRect
class_name knob

signal state_changed(current_state: bool)

var is_on: bool = false
var enabled: bool = true

func _on_mouse_entered() -> void:
	if enabled: material.set_shader_parameter("enable", true)
	

func _on_mouse_exited() -> void:
	material.set_shader_parameter("enable", false)


func _on_gui_input(event: InputEvent) -> void:
	if enabled and event.is_action_pressed("mouse_left"):
		$KnobSound.play()
		rotation_degrees += 180
		is_on = !is_on
		state_changed.emit(is_on)

