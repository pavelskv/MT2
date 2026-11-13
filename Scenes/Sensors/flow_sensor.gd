extends Node3D
class_name sensor3


func set_value(value: float): #.pad_decimals(1)
	$Value.text = str(value).rpad(2, ".0") + " кг/с"
	#$Value.text = str(value).rpad(2, ".0") + "\nкг/с"
	#$Value.text = str(value).rpad(2, ".0") + " л/с"
	
	
func focused(is_focused: bool):
	$SensorZoomOverlay.visible = is_focused
