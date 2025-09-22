extends Menu
class_name MainMenu


@export var settings_menu: Menu


func _on_settings_pressed() -> void:
	close(true)
	await animation_finished
	settings_menu.open()
	await settings_menu.closed
	open()
