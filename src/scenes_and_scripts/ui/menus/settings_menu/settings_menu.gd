@tool
extends Menu
class_name SettingsMenu


@export var controls_menu: Menu

@onready var sound_master: VolumeSlider = $ControlSound/Sound/VBoxContainer/Master
@onready var sound_sfx: VolumeSlider = $ControlSound/Sound/VBoxContainer/SFX
@onready var sound_music: VolumeSlider = $ControlSound/Sound/VBoxContainer/Music


func _ready() -> void:
	load_settings()

func open(instant: bool = false) -> void:
	load_settings()
	super.open(instant)

func close(internal: bool = false) -> void:
	save_settings()
	await super.close(internal)

func save_settings() -> void:
	var file: ConfigFile = ConfigFile.new()
	file.set_value("sound", "Master", sound_master.value)
	file.set_value("sound", "SFX", sound_sfx.value)
	file.set_value("sound", "Music", sound_music.value)
	file.save("user://settings.cfg")

func load_settings() -> void:
	var file: ConfigFile = ConfigFile.new()
	# Because of web
	sound_master.value = 0.0
	sound_master.value = 100.0
	sound_sfx.value = 0.0
	sound_sfx.value = 100.0
	sound_music.value = 0.0
	sound_music.value = 100.0
	if file.load("user://settings.cfg") != OK:
		return
	sound_master.value = file.get_value("sound", "Master", 100.0)
	sound_sfx.value = file.get_value("sound", "SFX", 100.0)
	sound_music.value = file.get_value("sound", "Music", 100.0)

func open_controls_menu() -> void:
	open_sub_menu(controls_menu)

func _on_reset_save_pressed() -> void:
	Settings.reset()
	Settings._save()
	if OS.has_feature("web"):
		JavaScriptBridge.eval("location.reload();")
	else:
		OS.shell_open(OS.get_executable_path())
		get_tree().quit()
