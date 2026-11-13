extends Node3D

@export_category("Camera flow settings")
@export var camera: Camera3D
@export var camera_path: PathFollow3D
@export var camera_speed: float = 0.5


func _process(delta: float) -> void:
	if visible:
		if camera_path.progress_ratio != 1:
			camera_path.progress += camera_speed * delta
		else: %RoomController.cutscene_err7_finished = true
		
		
			


func _on_visibility_changed() -> void:
	if visible:
		print("opana")
		$"../Character"/CenterContainer.visible = false
		GameController.is_cutscene = true
		camera.current = true
	else:
		GameController.mouse_visible = false
		camera.current = false

