@tool
extends Menu
class_name RespawnMenu


@export var settings_menu: Menu

signal respawn
signal exit_level

@onready var message_text: RichTextLabel = $Header/Message
@onready var energy_collected_text: RichTextLabel = $Header/EnergyCollected


func open_with_message(message: String) -> void:
	message_text.text = message
	var color: String = "white"
	if Settings.level_collected_energy >= 500: color = "lime"
	elif Settings.level_collected_energy >= 250: color = "yellow"
	elif Settings.level_collected_energy >= 100: color = "lightblue"
	elif Settings.level_collected_energy < 0: color = "red"
	energy_collected_text.text = "[color=" + color + "]" + ("+" if Settings.level_collected_energy >= 0 else "") + str(int(Settings.level_collected_energy)) + " E[/color]"
	open()


func _on_respawn_pressed() -> void:
	respawn.emit()

func _on_settings_pressed() -> void:
	open_sub_menu(settings_menu)

func _on_exit_level_pressed() -> void:
	exit_level.emit()
