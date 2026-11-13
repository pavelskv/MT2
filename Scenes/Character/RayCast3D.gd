extends RayCast3D

var old_collider : Object

@onready var CrosshairBasic: TextureRect = $"../../../CenterContainer/CrosshairBasic"
@onready var CrosshairHandOpened: TextureRect = $"../../../CenterContainer/CrosshairHandOpened"
@onready var CrosshairHandClosed: TextureRect = $"../../../CenterContainer/CrosshairHandClosed"



func _physics_process(_delta:float) -> void:
	var new_collider : Object
	
	if is_colliding():
		new_collider = get_collider().owner

		if "focused" in new_collider:
			var exceptions: bool = new_collider is sensor1 or new_collider is sensor2 or \
									new_collider is sensor3 or new_collider is sensor4 or \
									new_collider is repairlogos or new_collider is leak or \
									new_collider is coll_for_err6 or \
									
									# NEW
									GameController.sensor_visible  or \
									new_collider.name == "vibro" or \
									
									(new_collider.name in 
									["Pump1", "Podshipnik2", "Podshipnik3"] \
									and not GameController.pump1_running)
	
			
			if not exceptions:
				CrosshairBasic.visible = false
			
				CrosshairHandOpened.visible = true
					
				if Input.is_action_pressed("mouse_left") and CrosshairHandOpened.visible:
					CrosshairHandOpened.visible = false
					CrosshairHandClosed.visible = true
							
				if Input.is_action_just_released("mouse_left") and CrosshairHandClosed.visible:
					CrosshairHandClosed.visible = false
					CrosshairHandOpened.visible = true
					
					
			new_collider.focused(true)
			
			if !GameController.is_cutscene:
				if Input.is_action_just_pressed("mouse_left"):
					if "on_click" in new_collider:
						new_collider.on_click()
			
			# NEW
			if GameController.sensor_visible or GameController.briefing_visible:
				CrosshairHandOpened.visible = false
				CrosshairHandClosed.visible = false
				
				CrosshairBasic.visible = true
	else:
		CrosshairHandOpened.visible = false
		CrosshairHandClosed.visible = false
		CrosshairBasic.visible = true


	if new_collider == old_collider:
		return

	if old_collider == null:
		# raycast entered new_collider
		if "focused" in new_collider:
			new_collider.focused(true)
	else:
		# raycast exited old_collider...
		if "focused" in old_collider :
			old_collider.focused(false)
		
		# ...and changed to new_collider
		if new_collider != null && "focused" in new_collider:
			new_collider.focused(true)

	old_collider = new_collider
	
	
