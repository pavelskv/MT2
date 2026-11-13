extends Control

@onready var check_button_err_6: CheckButton = $MarginContainer/Panel/VBoxContainer/MarginContainerPanelPic/VBoxContainer/CheckButtonErr6
@onready var check_button_err_7: CheckButton = $MarginContainer/Panel/VBoxContainer/MarginContainerPanelPic/VBoxContainer/CheckButtonErr7
@onready var check_button_err_8: CheckButton = $MarginContainer/Panel/VBoxContainer/MarginContainerPanelPic/VBoxContainer/CheckButtonErr8
@onready var check_button_err_9: CheckButton = $MarginContainer/Panel/VBoxContainer/MarginContainerPanelPic/VBoxContainer/CheckButtonErr9
@onready var check_button_err_10: CheckButton = $MarginContainer/Panel/VBoxContainer/MarginContainerPanelPic/VBoxContainer/CheckButtonErr10
@onready var check_button_broken: CheckButton = $MarginContainer/Panel/VBoxContainer/MarginContainerPanelPic/VBoxContainer/CheckButtonErrBroken

func _ready() -> void:
	await get_tree().process_frame
	visibility_changed.connect(_on_visibility_changed)

func _on_continue_button_pressed():
	set_params()
	visible = false

func set_params() -> void:
	%RoomController.error6 = check_button_err_6.button_pressed
	%RoomController.error7 = check_button_err_7.button_pressed
	%RoomController.error8 = check_button_err_8.button_pressed
	%RoomController.error9 = check_button_err_9.button_pressed
	%RoomController.error10 = check_button_err_10.button_pressed
	
	%Pump2Valve1.broken = check_button_broken.button_pressed

func _on_visibility_changed():
	GameController.mouse_visible = visible
	GameController.is_cutscene = visible

func _on_rich_text_label_2_meta_clicked(meta):
	openPdf(str(meta))
	
func openPdf(path):
	OS.shell_open(path)
