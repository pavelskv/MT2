extends Node3D
class_name sensor4

## Активен ли регулятор для взаимодействия
@export var enabled: bool = true:
	set(value):
		enabled = value
		$electro/StaticBody3D.set_collision_layer_value(2, value)
	get: return(enabled)
	

## Начальное значение слайдера
@export var slider_start_value: int = 0:
	set(value):
		slider_start_value = value
		$Slider.start_value = slider_start_value
	get: return(slider_start_value)
	
## Активен ли слайдер для управления колесиком мыши
@export var slider_wheel_enabled: bool = true:
	set(value):
		slider_wheel_enabled = value
		$Slider.wheel_enabled = slider_wheel_enabled
	get: return(slider_wheel_enabled)

## Можно ли управлять слайдером через колесико мышки вверх
@export var slider_wheel_up_enabled: bool = true:
	set(value):
		slider_wheel_up_enabled = value
		$Slider.wheel_up_enabled = slider_wheel_up_enabled
	get: return(slider_wheel_up_enabled)
	
## Можно ли управлять слайдером через колесико мышки вверх
@export var slider_wheel_down_enabled: bool = true:
	set(value):
		slider_wheel_down_enabled = value
		$Slider.wheel_down_enabled = slider_wheel_down_enabled
	get: return(slider_wheel_down_enabled)

## Настройки насоса и его звука
@export_category("Pump and pitch")
@export var pump: pump1:
	set(value):
		pump = value
		$Slider.pump = value
	get: return(pump)
	
@export var pump_pitch_min: float = 1:
	set(value):
		pump_pitch_min = value
		$Slider.pitch_min = value
	get: return(pump_pitch_min)
	
@export var pump_pitch_max: float = 1.12:
	set(value):
		pump_pitch_max = value
		$Slider.pitch_max = value
	get: return(pump_pitch_max)

func focused(is_focused: bool):
	if enabled:
		$electro.material_overlay.next_pass.set_shader_parameter("enable", is_focused)
		$Slider.visible = is_focused
		
func setDirection(increase: bool):
	slider_wheel_up_enabled = increase
	slider_wheel_down_enabled = not increase
