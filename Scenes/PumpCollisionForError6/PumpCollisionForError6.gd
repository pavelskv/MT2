extends MeshInstance3D
class_name coll_for_err6

#func focused(is_focused: bool):
	#if %RoomController.error6_active:
		#$AnimatedBolt.visible = is_focused

