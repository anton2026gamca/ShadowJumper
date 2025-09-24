extends Menu
class_name SettingsMenu


@export var controls_menu: Menu

@onready var sound_master: VolumeSlider = $ControlSound/Sound/VBoxContainer/Master
@onready var sound_sfx: VolumeSlider = $ControlSound/Sound/VBoxContainer/SFX
@onready var sound_music: VolumeSlider = $ControlSound/Sound/VBoxContainer/Music


func _ready() -> void:
	load_settings()

func open() -> void:
	load_settings()
	super.open()

func close(internal: bool = false) -> void:
	super.close(internal)
	save_settings()

func save_settings() -> void:
	var file: ConfigFile = ConfigFile.new()
	file.set_value("sound", "Master", sound_master.value)
	file.set_value("sound", "SFX", sound_sfx.value)
	file.set_value("sound", "Music", sound_music.value)
	file.save("user://settings.cfg")

func load_settings() -> void:
	var file: ConfigFile = ConfigFile.new()
	if file.load("user://settings.cfg") != OK:
		return
	sound_master.value = file.get_value("sound", "Master", 100.0)
	sound_sfx.value = file.get_value("sound", "SFX", 100.0)
	sound_music.value = file.get_value("sound", "Music", 100.0)

func open_controls_menu() -> void:
	open_sub_menu(controls_menu)
