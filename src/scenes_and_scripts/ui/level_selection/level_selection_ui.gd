extends Control
class_name LevelSelectionUi


@onready var debug_text: RichTextLabel = $DebugText
@onready var total_energy_label: Label = $TotalEnergyDisplay/Label
@onready var total_energy_add_audio: AudioStreamPlayer = $TotalEnergyDisplay/AddAudio
@onready var enegry_text_spawner: Node2D = $EnegryTextSpawner


func _ready() -> void:
	total_energy_label.text = str(int(Settings.total_collected_energy)) + " E"
	if not OS.is_debug_build():
		debug_text.visible = false

func collected_energy_animation() -> void:
	if Settings.level_collected_energy == 0: return
	var color: Color = Color.WHITE
	if Settings.level_collected_energy >= 400: color = Color.LIME
	elif Settings.level_collected_energy >= 200: color = Color.YELLOW
	elif Settings.level_collected_energy >= 100: color = Color.LIGHT_YELLOW
	elif Settings.level_collected_energy < 0: color = Color.RED
	var text: FloatingText = Helpers.create_floating_text(enegry_text_spawner, ("+" if Settings.level_collected_energy >= 0 else "") + str(int(Settings.level_collected_energy)), Vector2.ZERO, color, -32)
	text.add_theme_font_size_override("font_size", 18)
	total_energy_add_audio.play()
	var total_before_level: float = Settings.total_collected_energy - Settings.level_collected_energy
	while abs(Settings.level_collected_energy) > 0.5:
		var val: float = 60 * get_physics_process_delta_time()
		if Settings.level_collected_energy < 0: val = -val
		Settings.level_collected_energy -= val
		total_before_level += val
		total_energy_label.text = "Collected Energy: " + str(int(total_before_level)) + " E"
		if text: text.text = ("+" if Settings.level_collected_energy > 0 else "") + str(int(Settings.level_collected_energy))
		await get_tree().process_frame
	total_energy_add_audio.stop()
	Settings.level_collected_energy = 0
	total_energy_label.text = "Collected Energy: " + str(int(total_before_level)) + " E"
	Settings._save()
