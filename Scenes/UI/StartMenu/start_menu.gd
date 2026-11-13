extends CanvasLayer

@export var skip_start_menu: bool = false

@export_category("Camera flow settings")
@export var camera: Camera3D
@export var camera_path: PathFollow3D
@export var camera_speed: float = 0.5


func _ready() -> void:

	if skip_start_menu or GameController.first_start_occured:
		visible = false
		$"../Character"/CenterContainer.visible = true
	else:
		$"../Tasks_menu".visible = false
		GameController.first_start_occured = true
		GameController.is_cutscene = true

		GameController.set_deferred("mouse_visible", true)
		camera.current = true

func _process(delta: float) -> void:
	camera_path.progress += camera_speed * delta

func show_controls() -> void:
	get_tree().set_group("StartMenu_TaskPage", "visible", false)
	get_tree().set_group("StartMenu_MaterialsPage", "visible", false)
	get_tree().set_group("StartMenu_ControlsPage", "visible", true)

func show_task() -> void:
	get_tree().set_group("StartMenu_ControlsPage", "visible", false)
	get_tree().set_group("StartMenu_MaterialsPage", "visible", false)
	get_tree().set_group("StartMenu_TaskPage", "visible", true)
	
func show_materials() -> void:
	get_tree().set_group("StartMenu_ControlsPage", "visible", false)
	get_tree().set_group("StartMenu_TaskPage", "visible", false)
	get_tree().set_group("StartMenu_MaterialsPage", "visible", true)


func _on_controls_button_pressed() -> void:
	show_controls()


func _on_task_button_pressed() -> void:
	show_task()


func _on_materials_button_pressed() -> void:
	show_materials()

func _on_start_button_pressed() -> void:
	
	visible = false
	camera.current = false
	#$"/root/WinScreen".visible = false
	$"../Character"/Head/Camera3D.current = true
	$"../Character"/CenterContainer.visible = true

	
	$"../Tasks_menu".visible = true
	
	

func _on_rich_text_label_materials_meta_clicked(meta):
	OS.shell_open(str(meta))
