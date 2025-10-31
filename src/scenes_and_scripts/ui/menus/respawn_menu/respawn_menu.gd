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
	var energy_color: String = Helpers.get_energy_level_color(Progress.level_collected_energy).to_html(false)
	energy_collected_text.text = tr("STATS_COLLECTED_ENERGY_THIS_RUN") + "[color=#" + energy_color + "]" + ("+" if Progress.level_collected_energy > 0 else "") + str(int(Progress.level_collected_energy)) + tr("STATS_ENERGY_SUFFIX") + "[/color]"
	var rocks_color: String = "yellow"
	if Progress.level_rocks > 0: rocks_color = "lime"
	rocks_collected_text.text = tr("STATS_ROCKS_THIS_RUN") + "[color=" + rocks_color + "]" + ("+" if Progress.level_rocks > 0 else "") + str(int(Progress.level_rocks)) + tr("STATS_ROCKS_SUFFIX") + "[/color]"
	open()


func _on_respawn_pressed() -> void:
	respawn.emit()

func _on_settings_pressed() -> void:
	open_sub_menu(settings_menu)

func _on_exit_level_pressed() -> void:
	exit_level.emit()
