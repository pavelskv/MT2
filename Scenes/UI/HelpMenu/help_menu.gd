extends CanvasLayer

var can_hide: bool = false

func _ready() -> void:
	%RoomController.cutscene_ended.connect(func (): if not %Switch2D.visible: visible = true)
	%RoomController.cutscene_started.connect(func (): 
												visible = false 
												$ColorRectFull.visible = false
												can_hide = false)
	
	%EscMenu.pause_finished.connect(func (): if not %Switch2D.visible: visible = true)
	%EscMenu.pause_started.connect(func (): 
										visible = false 
										$ColorRectFull.visible = false
										can_hide = false)
	
	call_deferred("init_show")
	
func init_show() -> void:
	if not GameController.is_cutscene:
		visible = true

func _process(_delta: float) -> void:
	if GameController.is_cutscene or get_tree().paused: return
	
	if Input.is_action_just_pressed("F1"):
		can_hide = false
		$Timer.start(0.1)
		$ColorRectFull.visible = true
	
	if Input.is_anything_pressed() and can_hide and not Input.is_action_pressed("F1"):
		$ColorRectFull.visible = false
		
	


func _on_timer_timeout() -> void:
	can_hide = true
