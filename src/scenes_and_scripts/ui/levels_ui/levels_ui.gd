extends Control
class_name LevelsUI

@onready var pause_menu: PauseMenu = $PauseMenu
@onready var respawn_menu: RespawnMenu = $RespawnMenu
@onready var full_screen_text: RichTextLabel = $FullScreenText

@export var node_indicator_scene: PackedScene

@export var camera: Camera2D

var playing_level: bool = false

signal exit_level
signal respawn


func _ready() -> void:
	Helpers.levels_ui = self
	reset()

func _process(_delta: float) -> void:
	pass


func reset() -> void:
	resume()
	destroy_all_indicators()

func pause() -> void:
	if get_tree().paused: return
	pause_menu.open()
	get_tree().paused = true

func resume() -> void:
	if not get_tree().paused or respawn_menu.is_open: return
	print("resuming")
	await pause_menu.close()
	get_tree().paused = false

func open_respawn_menu(text: String) -> void:
	get_tree().paused = true
	respawn_menu.open_with_message(text)

func _on_exit_level_pressed() -> void:
	respawn_menu.close()
	resume()
	exit_level.emit()

func _on_respawn_menu_respawn() -> void:
	respawn_menu.close()
	respawn.emit()
	get_tree().paused = false

func create_node_indicator(target: Node2D) -> NodeIndicator:
	var node_indicator: NodeIndicator = node_indicator_scene.instantiate()
	node_indicator.target = target
	node_indicator.origin_point = camera
	add_child(node_indicator)
	return node_indicator

func destroy_all_indicators() -> void:
	for indicator: NodeIndicator in get_children().filter(func (child: Node) -> bool: return child is NodeIndicator):
		if indicator: indicator.destroy.call_deferred()
