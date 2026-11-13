extends CharacterBody3D

const WALK_SPEED = 2
const SENSITIVITY = 0.002

#bob variables
const BOB_FREQ = 5.42
const BOB_AMP = 0.02
var t_bob = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

@onready var footsteps_sound_length = $Footsteps.stream.get_length()

@onready var head = $Head
@onready var camera = $Head/Camera3D

var is_pirometr_visible: bool:
	set(value): 
		is_pirometr_visible = value
		$Head/Camera3D/pirometr.visible = is_pirometr_visible
		
		$CenterContainer.visible = !is_pirometr_visible
		
	get: return is_pirometr_visible

func set_pirometr_value(value: int):
	$Head/Camera3D/pirometr/Value.text = str(value) + "°C"


func _ready():
	pass

func _input(event): #func _unhandled_input(event):
	if GameController.is_cutscene: return
	
	# Mouse look
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(50))
		
	# Zoom camera
	#if Input.is_action_pressed("mouse_right"):
		#camera.fov = 40 
		  
	#if Input.is_action_just_released("mouse_right"):
		#camera.fov = 75  




func _physics_process(delta):
	# Zoom camera
	if Input.is_action_pressed("mouse_right"):
		camera.fov = 40 
	else: camera.fov = 75  
		
		
	if GameController.is_cutscene: 
		$Footsteps.stop()
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction != Vector3.ZERO:
			velocity.x = direction.x * WALK_SPEED
			velocity.z = direction.z * WALK_SPEED
			if !$Footsteps.playing && !GameController.is_cutscene:
				
				$Footsteps.play()
				$Footsteps.seek(randf_range(0, footsteps_sound_length))
		else:
			velocity.x = lerp(velocity.x, direction.x * WALK_SPEED, delta * 9.5)
			velocity.z = lerp(velocity.z, direction.z * WALK_SPEED, delta * 9.5)
			$Footsteps.stop()
	else:
		velocity.x = lerp(velocity.x, direction.x * WALK_SPEED, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * WALK_SPEED, delta * 3.0)
		$Footsteps.stop()
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
