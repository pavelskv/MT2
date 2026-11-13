extends MeshInstance3D

## Скорость расползания лужи в секундах
@export var speed_in_sec: float = 9

@onready var tween = create_tween()

func _ready() -> void:
	become_default()

func become_default() -> void:
	if tween.is_running():
		tween.kill()
	
	$".".mesh.top_radius = 0.5
	$".".mesh.bottom_radius = 0.5
	
func become_large() -> void:
	become_default()
	
	# create tween
	tween = create_tween()
	
	# animation parameters
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property($".", "mesh:top_radius", 7.2, speed_in_sec)
	tween.parallel().tween_property($".", "mesh:bottom_radius", 8.3, speed_in_sec)
