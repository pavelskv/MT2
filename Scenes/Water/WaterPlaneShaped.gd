extends Node3D

func start_flood() -> void:
	# Делаем видимой воду
	self.visible = true
	
	# Поднимаем уровень воды
	var tween = create_tween()
	#tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT)
		
	tween.tween_property(self, "position", Vector3(0.221, 0.145, 0.0), 18)

