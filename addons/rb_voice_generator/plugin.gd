@tool
extends EditorPlugin

enum Dialog {
	AUTO,
	MANUAL
}

var auto_dialog_window: Window
var manual_dialog_window: Window

var sub_menu: PopupMenu
const dialog_menu_text := "RB Voice Generator"
const auto_dialog_menu_text := "Автоматическая генерация"
const manual_dialog_menu_text := "Ручная генерация"


var auto_voice_generator_scene
var manual_voice_generator_scene

func _enter_tree() -> void:
	Engine.set_meta("RBVG_Plugin", self)
	
	# Предзагружаем все необходимые сцены интерфейса
	auto_voice_generator_scene = preload("res://addons/rb_voice_generator/editor/window_dialogs/auto/rbvg_auto.tscn").instantiate()
	manual_voice_generator_scene = preload("res://addons/rb_voice_generator/editor/window_dialogs/manual/rbvg_manual.tscn").instantiate()

	
	# Создаем меню с вложенными пунктами по пути "Project -> Tools"
	sub_menu = PopupMenu.new()
	sub_menu.add_item(auto_dialog_menu_text)
	sub_menu.add_item(manual_dialog_menu_text)
	add_tool_submenu_item(dialog_menu_text, sub_menu)
	
	# Соединяем сигнал для обработки нажатого пункта меню
	sub_menu.index_pressed.connect(_show_dialog)

	# Создаем окна интерфейса и подключаем сигналы для обработки закрытия окон
	auto_dialog_window = _init_dialog_window(auto_dialog_menu_text, auto_voice_generator_scene)
	manual_dialog_window = _init_dialog_window(manual_dialog_menu_text, manual_voice_generator_scene)



func _init_dialog_window(window_title: String, interface_scene: Node) -> Window:
	var dialog_window = Window.new()
	dialog_window.title = window_title
	#dialog_window.unresizable = true
	dialog_window.set_unparent_when_invisible(true)
	dialog_window.close_requested.connect(func (): dialog_window.hide())
	dialog_window.add_child(interface_scene)
	
	return dialog_window

	
func _show_dialog(id: int) -> void:
	match id:
		Dialog.AUTO:
			EditorInterface.popup_dialog_centered(auto_dialog_window, Vector2i(800, 900))
			auto_dialog_window.get_child(0).on_show()
		Dialog.MANUAL:
			EditorInterface.popup_dialog_centered(manual_dialog_window, Vector2i(450, 500))
			manual_dialog_window.get_child(0).on_show()



func _get_plugin_icon() -> Texture2D:
	return EditorInterface.get_editor_theme().get_icon("AudioStreamOggVorbis", "EditorIcons")

	
func _exit_tree() -> void:
	Engine.remove_meta("RBVG_Plugin")
	
	remove_tool_menu_item(dialog_menu_text)
	auto_dialog_window.queue_free()
	manual_dialog_window.queue_free()
	
	auto_voice_generator_scene.queue_free()
	manual_voice_generator_scene.queue_free()
