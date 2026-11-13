extends Node3D

var is_animating: bool = false

var pump: pump1
var pitch_min: float = 1
var pitch_max: float = 1.12
var pitch_one_percent: float

# Начальная позиция стрелки
@onready var init_pos: float = %Arrow.position.x

# Самая левая и правая возмоные координаты стрелки
var arrow_most_left_pos: float = -206 #-254
var arrow_most_right_pos: float = 318 #270

# Длина шкалы и длина шага в одно деление
@onready var scale_length: float = abs(arrow_most_left_pos) + abs(arrow_most_right_pos)
@onready var scale_step: float = scale_length / max_value

#########################################################

## Стартовое значение
@export var start_value: int = 0

# Минимальные и максимальные значения шкалы
@export var min_value: int = 0
@export var max_value: int = 100

@export var show_deny: bool = false:
	get: return show_deny
	set(value):
		show_deny = value
		$Subviewport/Control/CloseDeny.visible = show_deny

@export_category("Mouse Controls")
## Можно ли управлять слайдером через колесико мышки
@export var wheel_enabled: bool = true:
	set(value):
		wheel_enabled = value
		if wheel_enabled: %MouseTooltip.show()
		else: %MouseTooltip.hide()
	get: return(wheel_enabled)
## Можно ли управлять слайдером через колесико мышки вверх
@export var wheel_up_enabled: bool = true
## Можно ли управлять слайдером через колесико мышки вниз
@export var wheel_down_enabled: bool = true
## Величина шага при управлении мышкой
@export var jump_step: float = 10

#########################################################

# Текущее значение на шкале
var value: int = 0:
	get: return value
	set(new_value): 
		value = new_value
		%Value.text = str(value) + "%"
		pump.set_pitch(pitch_min + value * pitch_one_percent)
		

func _ready() -> void:
	value = start_value
	%Arrow.position.x = init_pos + value * scale_step
	
	pitch_one_percent = (pitch_max - pitch_min) / 100


func slide_to(percent: int) -> void:
	if is_animating: return
	else: is_animating = true
	
	# Не дадим выбраться за границы дозволенного :)
	percent = clamp(percent, min_value, max_value)

	var tween = create_tween()
	
	# Параметры анимаций
	#tween.set_trans(Tween.TRANS_CIRC)
	tween.set_ease(Tween.EASE_IN)

	tween.tween_property(%Arrow, "position:x", init_pos + percent * scale_step, 2)
	tween.parallel().tween_property(self, "value", percent, 2)
	
	await tween.finished
	
	# Чтобы успела сработать проверка условия в RBCM
	await get_tree().create_timer(0.51).timeout
	#await RBCM_GameClient.find_node("%RoomController").wait(0.51)
	
	is_animating = false



func _process(_delta: float) -> void:
	
	# DEBUG
	#print(%Arrow.position.x)
	#
	#if Input.is_action_pressed("left"):
		#%Arrow.position.x -= 1
	#if Input.is_action_pressed("right"):
		#%Arrow.position.x += 1	
	
	
	if wheel_enabled and visible:
		if Input.is_action_just_pressed("mouse_wheel_up") and wheel_up_enabled:
			slide_to(int(value + jump_step))
			
		if Input.is_action_just_pressed("mouse_wheel_down") and wheel_down_enabled:
			slide_to(int(value - jump_step))
