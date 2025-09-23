extends Menu
class_name PauseMenu


@export var settings_menu: Menu

signal exit_level


func _on_exit_level_pressed() -> void:
	exit_level.emit()

func _on_settings_pressed() -> void:
	open_sub_menu(settings_menu)
