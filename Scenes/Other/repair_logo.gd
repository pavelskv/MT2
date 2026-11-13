extends Sprite3D
class_name repairlogos

signal repair_done

const REPAIR_DONE = preload("res://Assets/UI/repair_done.png")
var new_texture_set: bool = false

#var focusable: bool = false:
	#get: return focusable
	#set(value):
		#focusable = value
		#$Area3D.set_collision_layer_value(2, focusable)


func focused(is_focused: bool):
	if not get_parent().visible: return

	
	if is_focused and not new_texture_set:
		texture = REPAIR_DONE
		new_texture_set = true
		$AudioStreamPlayer.play()
		repair_done.emit()


func _on_visibility_changed() -> void:
	$Area3D.set_collision_layer_value(2, visible)
