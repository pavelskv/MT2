extends CanvasLayer

@onready var scroll = $Panel/MarginContainer/VBoxContainer/TextLabel.get_v_scroll_bar() as VScrollBar

func _ready() -> void:
	await get_tree().process_frame
	visibility_changed.connect(_on_visibility_changed)
	scroll.value_changed.connect(is_read)
	
func is_read(value: float) -> void:
	if value >= scroll.max_value - scroll.page:
		$Panel/MarginContainer/VBoxContainer/AcceptButton.disabled = false

func _on_accept_button_pressed() -> void:
	visible = false

func _on_visibility_changed() -> void:
	if visible:
		GameController.briefing_visible = true
		GameController.is_cutscene = true
		GameController.mouse_visible = true
	else:
		GameController.briefing_visible = false
		GameController.mouse_visible = false
		GameController.is_cutscene = false
