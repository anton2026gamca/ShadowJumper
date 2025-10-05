extends Control
class_name LevelSelectionUi


@onready var bottom_right_text: RichTextLabel = $BottomRightText
@onready var total_energy_label: Label = $TotalEnergyDisplay/Label
@onready var total_energy_add_audio: AudioStreamPlayer = $TotalEnergyDisplay/AddAudio
@onready var enegry_text_spawner: Node2D = $EnegryTextSpawner


func _ready() -> void:
	total_energy_label.text = str(int(Settings.total_energy)) + " E"
	if not OS.is_debug_build():
		bottom_right_text.text = bottom_right_text.text.replace("[color=green]DEBUG BUILD[/color]\nPress [color=lightblue]L[/color] to unlock all levels", "")


func add_collected_energy_to_total() -> void:
	if Settings.collected_energy == 0:
		return
	var color: Color = Color.WHITE
	if Settings.collected_energy >= 500: color = Color.LIME
	elif Settings.collected_energy >= 250: color = Color.YELLOW
	elif Settings.collected_energy >= 100: color = Color.LIGHT_BLUE
	elif Settings.collected_energy < 0: color = Color.RED
	var text: FloatingText = Helpers.create_floating_text(enegry_text_spawner, ("+" if Settings.collected_energy >= 0 else "") + str(int(Settings.collected_energy)), Vector2.ZERO, color, -32)
	text.add_theme_font_size_override("font_size", 18)
	total_energy_add_audio.play()
	while abs(Settings.collected_energy) > 0.5:
		var val: float = 60 * get_physics_process_delta_time()
		if Settings.collected_energy < 0: val = -val
		Settings.collected_energy -= val
		Settings.total_energy += val
		total_energy_label.text = "Collected Energy: " + str(int(Settings.total_energy)) + " E"
		if text: text.text = ("+" if Settings.collected_energy >= 0 else "") + str(int(Settings.collected_energy))
		await get_tree().process_frame
	total_energy_add_audio.stop()
	Settings.total_energy += Settings.collected_energy
	Settings.collected_energy = 0
	total_energy_label.text = "Collected Energy: " + str(int(Settings.total_energy)) + " E"
	Settings._save()
