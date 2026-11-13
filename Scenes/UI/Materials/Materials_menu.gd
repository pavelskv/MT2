extends Control


func _on_continue_button_pressed():
	visible = false
	
	# Включить отображение основного меню
	owner.visibility(true)
	
	# Перейти сразу в игру
	owner.visible = false


func _on_rich_text_label_task_meta_clicked(meta):
	OS.shell_open(str(meta))
