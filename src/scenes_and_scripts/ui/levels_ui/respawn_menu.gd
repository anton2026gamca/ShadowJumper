extends Menu
class_name RespawnMenu


@export var settings_menu: Menu

signal respawn
signal exit_level

@onready var message_text: RichTextLabel = $Header/Message


func open_with_message(message: String) -> void:
	message_text.text = message
	open()


func _on_respawn_pressed() -> void:
	respawn.emit()

func _on_settings_pressed() -> void:
	open_sub_menu(settings_menu)

func _on_exit_level_pressed() -> void:
	exit_level.emit()
