class_name poster extends Node3D


@export var enabled : bool = true:
	get: return(enabled)
	set(value):
		enabled = value
		_make_enabled(value)
		
		
func _ready() -> void:
	_make_enabled(enabled)


func focused(is_focused: bool):
	$Label3D.visible = is_focused
	$poster.material_overlay.next_pass.set_shader_parameter("enable", is_focused)

func on_click() -> void:
	visible = false
	$RemoveSound.play()

func _on_remove_sound_finished() -> void:
	queue_free()

func _make_enabled(value : bool):
	$poster/StaticBody3D.set_collision_layer_value(2, value)
