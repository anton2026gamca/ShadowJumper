extends Node


var last_level: NodePath
var last_entered_level: NodePath
var beated_levels: Array[NodePath] = []

var sfx_value: float = 100.0
var music_value: float = 100.0


func _enter_tree() -> void:
	pass

func _exit_tree() -> void:
	pass
