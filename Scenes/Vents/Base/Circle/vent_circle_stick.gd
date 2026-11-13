class_name vent_circle_stick extends Node3D

signal set_focused(is_focused: bool)
signal set_on_click

func focused(is_focused: bool):
	emit_signal("set_focused", is_focused)

func on_click():
	emit_signal("set_on_click")
