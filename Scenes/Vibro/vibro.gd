extends Node3D

var value: String = "0.0":
	get: return value
	set(new_value):
		value = new_value
		$Value.text = value + " mm/c"	
	
func focused(is_focused: bool):
	$SensorZoomOverlay.visible = is_focused
	
	#if %RoomController.error6_active:
		#$AnimatedBolt.visible = is_focused


