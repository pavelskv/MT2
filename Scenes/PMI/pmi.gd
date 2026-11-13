extends Node3D

func focused(is_focused : bool):
	$Label3D.visible = is_focused
	$prog.material_overlay.next_pass.set_shader_parameter("enable", is_focused)

func on_click() -> void:
	OS.shell_open("https://sdo.smolate.ru/kbase/resource/view/uid/f0a9cb74e18d217a5e425e6579346a79")
	%EscMenu.visible = true
