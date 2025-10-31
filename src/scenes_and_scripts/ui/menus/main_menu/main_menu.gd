@tool
extends Menu
class_name MainMenu


@export var settings_menu: Menu
@export var controls_menu: Menu


func _on_settings_pressed() -> void:
	open_sub_menu(settings_menu)

func _on_controls_pressed() -> void:
	open_sub_menu(controls_menu)

func _on_toggle_language_pressed() -> void:
	TranslationServer.set_locale("en" if TranslationServer.get_locale() == "ja" else "ja")
