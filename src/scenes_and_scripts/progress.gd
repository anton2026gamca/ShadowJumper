extends Node


const VERSION: int = 1

var last_level: int
var levels_data: Dictionary[int, Dictionary] = {}

signal collected_energy_changed
var total_collected_energy: float = 0
var level_collected_energy: float = 0
func collect_energy(value: float) -> void:
	if value == 0: return
	total_collected_energy += value
	level_collected_energy += value
	collected_energy_changed.emit()

var total_rocks: float = 0
var level_rocks: float = 0
signal rocks_changed
func collect_rocks(value: float) -> void:
	if value == 0: return
	total_rocks += value
	level_rocks += value
	rocks_changed.emit()

var player_lives: int = 1


signal loaded
signal saved


func _enter_tree() -> void:
	_load()

func _exit_tree() -> void:
	_save()


func reset() -> void:
	levels_data = {}
	total_collected_energy = 0
	level_collected_energy = 0
	last_level = 1
	player_lives = 1
	total_rocks = 0
	level_rocks = 0

func _save(path: String = "user://progress.json") -> void:
	var data: Dictionary[String, Variant] = {
		"version" = VERSION,
		"last_level" = last_level,
		"levels" = levels_data,
		"player_lives" = player_lives,
		"energy" = total_collected_energy,
		"rocks" = total_rocks,
	}
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t", false))

func _load(path: String = "user://progress.json") -> void:
	if not FileAccess.file_exists(path):
		return
	var json: String = FileAccess.get_file_as_string(path)
	var data: Dictionary = JSON.parse_string(json)
	if not data:
		return
	last_level = data.get("last_level", 1)
	var levels_data_raw: Dictionary = data.get("levels", {})
	for key: Variant in levels_data_raw.keys():
		if not key is int and (not key is String or not key.is_valid_int()):
			continue
		levels_data[int(key)] = levels_data_raw[key]
	player_lives = data.get("player_lives", 1)
	total_collected_energy = data.get("energy", 0)
	total_rocks = data.get("rocks", 0)
