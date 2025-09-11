extends Node2D
class_name LevelLoaderClass


@export var level_parent: Node
@export var current_level: PackedScene
@onready var ui: UI = $UICanvasLayer/UI

signal exit_level_signal


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func load_level(level: PackedScene) -> void:
	current_level = level
	var node: Level = level.instantiate()
	node.player_died.connect(player_died)
	level_parent.add_child.call_deferred(node)

func exit_level() -> void:
	var level: Level = level_parent.get_child(0)
	level_parent.remove_child(level)
	level.queue_free()
	exit_level_signal.emit()

func player_died(reason: String) -> void:
	ui.open_respawn_menu(reason)
	ui.respawn.connect(reload_level)

func reload_level() -> void:
	ui.respawn.disconnect(reload_level)
	level_parent.remove_child.call_deferred(level_parent.get_child(0))
	load_level(current_level)
