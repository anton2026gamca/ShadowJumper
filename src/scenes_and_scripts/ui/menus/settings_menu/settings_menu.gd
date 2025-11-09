@tool
extends Menu
class_name SettingsMenu


@export var controls_menu: Menu

@onready var sound_master: VolumeSlider = $ControlSound/Sound/VBoxContainer/MarginContainer/VBoxContainer/Master
@onready var sound_sfx: VolumeSlider = $ControlSound/Sound/VBoxContainer/MarginContainer/VBoxContainer/SFX
@onready var sound_music: VolumeSlider = $ControlSound/Sound/VBoxContainer/MarginContainer/VBoxContainer/Music


func _ready() -> void:
	super._ready()
	if not Engine.is_editor_hint():
		Settings.loaded.connect(update_from_settings)

func open(instant: bool = false) -> void:
	if not Engine.is_editor_hint():
		update_from_settings()
	super.open(instant)

func close(internal: bool = false) -> void:
	save_audio()
	await super.close(internal)

func save_audio() -> void:
	Settings.set_value(Settings.Category.AUDIO, ["master"], sound_master.value)
	Settings.set_value(Settings.Category.AUDIO, ["sfx"], sound_sfx.value)
	Settings.set_value(Settings.Category.AUDIO, ["music"], sound_music.value)
	Settings.save_to_file()

func update_from_settings() -> void:
	sound_master.value = 0.0
	sound_master.value = 100.0
	sound_sfx.value = 0.0
	sound_sfx.value = 100.0
	sound_music.value = 0.0
	sound_music.value = 100.0
	# ^ Because of web
	sound_master.value = Settings.get_value(Settings.Category.AUDIO, ["master"], 100.0)
	sound_sfx.value = Settings.get_value(Settings.Category.AUDIO, ["sfx"], 100.0)
	sound_music.value = Settings.get_value(Settings.Category.AUDIO, ["music"], 100.0)

func open_controls_menu() -> void:
	open_sub_menu(controls_menu)

func _on_reset_save_pressed() -> void:
	Progress.reset()
	Progress._save()
	if OS.has_feature("web"):
		JavaScriptBridge.eval("location.reload();")
	else:
		var exec_path := OS.get_executable_path()
		OS.execute(exec_path, [], false)
		get_tree().quit()
