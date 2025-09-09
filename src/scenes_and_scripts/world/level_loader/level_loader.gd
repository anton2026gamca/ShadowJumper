extends Node2D
class_name LevelLoaderClass


@export var level_parent: Node

signal exit_level_signal


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func load_level(level: PackedScene) -> void:
	level_parent.add_child(level.instantiate())

func exit_level() -> void:
	level_parent.remove_child(level_parent.get_child(0))
	exit_level_signal.emit()
