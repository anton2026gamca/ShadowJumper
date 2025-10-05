extends Node


var last_level: NodePath
var last_entered_level: NodePath
var beated_levels: Array[NodePath] = []

var total_energy: float = 0
signal collected_energy_changed
var collected_energy: float = 0:
	set(value):
		collected_energy = value
		collected_energy_changed.emit()
	get: return collected_energy

signal loaded
signal saved


func _enter_tree() -> void:
	_load()

func _exit_tree() -> void:
	_save()


func reset() -> void:
	collected_energy = 0
	total_energy = 0
	last_level = ^""
	last_entered_level = ^""
	beated_levels = []

func _save(path: String = "user://progress.dat") -> int:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file \"" + path + "\" for writing")
		return 1
	file.store_8(total_energy)
	var node_paths: Array[NodePath] = [last_level, last_entered_level]
	for node_path: NodePath in beated_levels:
		node_paths.append(node_path)
	file.store_8(node_paths.size())
	for node_path: NodePath in node_paths:
		var path_str: String = str(node_path)
		if path_str.left(len("Level/Level")) == "Level/Level":
			var val: int = int(path_str.substr(len("Level/Level")))
			file.store_8(255)
			file.store_8(val)
		else:
			var bytes: PackedByteArray = path_str.to_utf8_buffer()
			file.store_8(bytes.size())
			file.store_buffer(bytes)
	file.close()
	saved.emit()
	return 0

func _load(path: String = "user://progress.dat") -> int:
	var result: Array = []
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("Failed to open file \"" + path + "\" for reading")
		return 1
	total_energy = file.get_8()
	var count = file.get_8()
	for i: int in count:
		var path_str: String = ""
		var length: int = file.get_8()
		if length == 255:
			var num: int = file.get_8()
			path_str = "Level/Level" + str(num)
		else:
			var bytes: PackedByteArray = file.get_buffer(length)
			path_str = bytes.get_string_from_utf8()
		result.append(NodePath(path_str))
	file.close()
	
	if len(result) > 0: last_level = result[0]
	if len(result) > 1: last_entered_level = result[1]
	beated_levels = []
	for i: int in range(2, len(result)):
		beated_levels.append(result[i])
	loaded.emit()
	return 0
