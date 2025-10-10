extends Node


var last_level: NodePath
var last_entered_level: NodePath
var beated_levels: Array[NodePath] = []

signal collected_energy_changed
var total_collected_energy: float = 0
var level_collected_energy: float = 0
func collect(value: float) -> void:
	if value == 0: return
	total_collected_energy += value
	level_collected_energy += value
	collected_energy_changed.emit()

var disable_npcs: Array[int] = []

var player_lives: int = 1

signal loaded
signal saved


func _enter_tree() -> void:
	_load()

func _exit_tree() -> void:
	_save()


func reset() -> void:
	total_collected_energy = 0
	level_collected_energy = 0
	last_level = ^""
	last_entered_level = ^""
	beated_levels = []
	disable_npcs = []
	player_lives = 1

func _save(path: String = "user://progress.dat") -> int:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file \"" + path + "\" for writing")
		return 1
	file.store_32(total_collected_energy)
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
	file.store_8(len(disable_npcs))
	for id: int in disable_npcs:
		file.store_8(id)
	file.store_8(player_lives)
	file.close()
	saved.emit()
	return 0

func _load(path: String = "user://progress.dat") -> int:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("Failed to open file \"" + path + "\" for reading")
		return 1
	total_collected_energy = file.get_32()
	beated_levels = []
	for i: int in file.get_8():
		var path_str: String = ""
		var length: int = file.get_8()
		if length == 255:
			var num: int = file.get_8()
			path_str = "Level/Level" + str(num)
		else:
			var bytes: PackedByteArray = file.get_buffer(length)
			path_str = bytes.get_string_from_utf8()
		var node_path: NodePath = NodePath(path_str)
		if i == 0: last_level = node_path
		elif i == 1: last_entered_level = node_path
		else: beated_levels.append(node_path)
	for i: int in file.get_8():
		disable_npcs.append(file.get_8())
	player_lives = file.get_8()
	if player_lives < 1:
		player_lives = 1
	if file.get_error():
		reset()
		file.close()
		return 1
	file.close()
	loaded.emit()
	return 0
