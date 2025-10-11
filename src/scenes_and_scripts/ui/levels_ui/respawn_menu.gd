@tool
extends Menu
class_name RespawnMenu


@export var settings_menu: Menu

signal respawn
signal exit_level

@onready var message_text: RichTextLabel = $Header/VBoxContainer/Message
@onready var energy_collected_text: RichTextLabel = $Header/VBoxContainer/EnergyCollected
@onready var rocks_collected_text: RichTextLabel = $Header/VBoxContainer/RocksCollected


func open_with_message(message: String) -> void:
	message_text.text = message
	var energy_color: String = Helpers.get_energy_level_color(Settings.level_collected_energy).to_html(false)
	energy_collected_text.text = "Collected energy this run: [color=#" + energy_color + "]" + ("+" if Settings.level_collected_energy > 0 else "") + str(int(Settings.level_collected_energy)) + " E[/color]"
	var rocks_color: String = "yellow"
	if Settings.level_rocks > 0: rocks_color = "lime"
	rocks_collected_text.text = "Rocks this run: [color=" + rocks_color + "]" + ("+" if Settings.level_rocks > 0 else "") + str(int(Settings.level_rocks)) + " R[/color]"
	open()


func _on_respawn_pressed() -> void:
	respawn.emit()

func _on_settings_pressed() -> void:
	open_sub_menu(settings_menu)

func _on_exit_level_pressed() -> void:
	exit_level.emit()
