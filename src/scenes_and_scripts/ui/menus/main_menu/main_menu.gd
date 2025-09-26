@tool
extends Menu
class_name MainMenu


@export var settings_menu: Menu


func _on_settings_pressed() -> void:
	open_sub_menu(settings_menu)

func _on_quit_pressed() -> void:
	pass
