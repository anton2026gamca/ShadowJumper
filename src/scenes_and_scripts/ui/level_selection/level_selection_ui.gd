extends Control
class_name LevelSelectionUi


@onready var debug_text: RichTextLabel = $DebugText
@onready var total_energy_label: Label = $TotalEnergyDisplay/Label
@onready var total_energy_add_audio: AudioStreamPlayer = $TotalEnergyDisplay/AddAudio
@onready var enegry_text_spawner: Node2D = $EnegryTextSpawner


func _ready() -> void:
	total_energy_label.text = str(int(Settings.total_collected_energy)) + " E"
	total_energy_label.add_theme_color_override("font_color", Helpers.get_energy_level_color(Settings.total_collected_energy))
	if not OS.is_debug_build():
		debug_text.visible = false


func collected_energy_animation() -> void:
	if Settings.level_collected_energy == 0: return
	var text: FloatingText = Helpers.create_floating_text(enegry_text_spawner, ("+" if Settings.level_collected_energy >= 0 else "") + str(int(Settings.level_collected_energy)), Vector2.ZERO, Helpers.get_energy_level_color(Settings.level_collected_energy), -32)
	text.add_theme_font_size_override("font_size", 18)
	total_energy_add_audio.play()
	var total_before_level: float = Settings.total_collected_energy - Settings.level_collected_energy
	while abs(Settings.level_collected_energy) > 0.5:
		var val: float = 1.0
		if Settings.level_collected_energy < 0: val = -val
		Settings.level_collected_energy -= val
		total_before_level += val
		total_energy_label.text = str(int(total_before_level)) + " E"
		#total_energy_label.add_theme_color_override("font_color", Helpers.get_energy_level_color(total_before_level))
		print(total_before_level)
		if text: text.text = ("+" if Settings.level_collected_energy > 0 else "") + str(int(Settings.level_collected_energy))
		await get_tree().process_frame
	total_energy_add_audio.stop()
	Settings.level_collected_energy = 0
	total_energy_label.text = str(int(Settings.total_collected_energy)) + " E"
	total_energy_label.add_theme_color_override("font_color", Helpers.get_energy_level_color(Settings.total_collected_energy))
	Settings._save()
