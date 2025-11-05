extends Control
class_name LevelSelectionUi


@onready var debug_text: RichTextLabel = $DebugText
@onready var total_energy_label: Label = $TotalEnergyDisplay/HBoxContainer/EnergyText
@onready var total_energy_add_audio: AudioStreamPlayer = $TotalEnergyDisplay/AddAudio
@onready var enegry_text_spawner: Node2D = $EnegryTextSpawner


func _ready() -> void:
	total_energy_label.text = str(int(Progress.total_collected_energy)) + tr("STATS_ENERGY_SUFFIX")
	total_energy_label.add_theme_color_override("font_color", Helpers.get_energy_level_color(Progress.total_collected_energy))
	if not OS.is_debug_build():
		debug_text.visible = false


func collected_energy_animation() -> void:
	if Progress.level_collected_energy == 0: return
	var text: FloatingText = Helpers.create_floating_text(LevelLoader.level_ui_nodes, ("+" if Progress.level_collected_energy >= 0 else "") + str(int(Progress.level_collected_energy)), enegry_text_spawner.global_position, Helpers.get_energy_level_color(Progress.level_collected_energy), -32)
	text.add_theme_font_size_override("font_size", 18)
	text.process_mode = Node.PROCESS_MODE_ALWAYS
	total_energy_add_audio.play()
	var total_before_level: float = Progress.total_collected_energy - Progress.level_collected_energy
	if Progress.total_collected_energy < 0: Progress.total_collected_energy = 0
	while abs(Progress.level_collected_energy) > 0.5:
		var val: float = 1.0
		if Progress.level_collected_energy < 0: val = -val
		Progress.level_collected_energy -= val
		total_before_level += val
		if total_before_level < 0: total_before_level = 0
		total_energy_label.text = str(int(total_before_level)) + tr("STATS_ENERGY_SUFFIX")
		total_energy_label.add_theme_color_override("font_color", Helpers.get_energy_level_color(total_before_level))
		if text: text.text = ("+" if Progress.level_collected_energy > 0 else "") + str(int(Progress.level_collected_energy))
		await get_tree().process_frame
	total_energy_add_audio.stop()
	Progress.level_collected_energy = 0
	total_energy_label.text = str(int(Progress.total_collected_energy)) + tr("STATS_ENERGY_SUFFIX")
	total_energy_label.add_theme_color_override("font_color", Helpers.get_energy_level_color(Progress.total_collected_energy))
	Progress._save()
