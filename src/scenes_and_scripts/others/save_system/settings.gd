extends Node


const DEFAULT_FILE_PATH: String = "user://settings.json"
const Category: Dictionary = {
	AUDIO = "audio",
	CONTROLS = "controls"
}

var data: Dictionary[String, Dictionary] = {}

signal saved
signal loaded

func _ready() -> void:
	load_from_file.call_deferred()


func save_to_file(path: String = DEFAULT_FILE_PATH) -> void:
	var json: String = JSON.stringify(data, "\t", false)
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json)
	saved.emit()

func load_from_file(path: String = DEFAULT_FILE_PATH) -> void:
	if not FileAccess.file_exists(path):
		return
	var json: String = FileAccess.get_file_as_string(path)
	var raw_data: Variant = JSON.parse_string(json)
	data = {}
	if raw_data is Dictionary:
		for key: Variant in raw_data.keys():
			if key is String and Category.values().has(key):
				data[key] = raw_data[key]
	loaded.emit()

func set_value(category: String, path: Array[Variant], value: Variant) -> Variant:
	if not Category.values().has(category):
		return null
	if not data.has(category):
		data[category] = {}
	return Helpers.dictionary_set_path(data[category], path, value, true)

func get_value(category: String, path: Array[Variant], default: Variant = null) -> Variant:
	if not Category.values().has(category) or not data.has(category):
		return default
	return Helpers.dictionary_get_path(data[category], path, default)
