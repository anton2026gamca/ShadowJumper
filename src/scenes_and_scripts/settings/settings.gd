extends Node


var last_level: NodePath
var last_entered_level: NodePath
var beated_levels: Array[NodePath] = []


func _enter_tree() -> void:
	_load()

func _exit_tree() -> void:
	_save()


func _save(path: String = "user://progress.dat") -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file for writing")
		return
	var node_paths: Array[NodePath] = [last_level, last_entered_level]
	for node_path: NodePath in beated_levels:
		node_paths.append(node_path)
	file.store_32(node_paths.size())
	for node_path: NodePath in node_paths:
		var path_str: String = str(node_path)
		var bytes: PackedByteArray = path_str.to_utf8_buffer()
		file.store_32(bytes.size())
		file.store_buffer(bytes)
	file.close()

func _load(path: String = "user://progress.dat") -> int:
	var result: Array = []
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file for reading")
		return 1
	var count = file.get_32()
	for i: int in count:
		var length: int = file.get_32()
		var bytes: PackedByteArray = file.get_buffer(length)
		var path_str: String = bytes.get_string_from_utf8()
		result.append(NodePath(path_str))
	file.close()
	
	if len(result) > 0: last_level = result[0]
	if len(result) > 1: last_entered_level = result[1]
	beated_levels = []
	for i: int in range(2, len(result)):
		beated_levels.append(result[i])
	return 0
