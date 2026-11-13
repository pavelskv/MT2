extends SubViewportContainer

@export var camera: Camera3D

func _ready() -> void:
	#%Camera3D.environment = get_viewport().world_3d.environment
	#$SubViewport.world_3d = get_viewport().world_3d
	%Camera3D.projection = camera.projection
	%Camera3D.fov = camera.fov
	%Camera3D.cull_mask = camera.cull_mask
	%Camera3D.global_transform = camera.global_transform
