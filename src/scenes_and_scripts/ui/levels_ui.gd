extends Control
class_name LevelsUI

@onready var pause_menu: Panel = $PauseMenu
@onready var resume_btn: Button = $PauseMenu/VBoxContainer/Control/Resume
@onready var respawn_menu: Panel = $RespawnMenu
@onready var respawn_btn: Button = $RespawnMenu/Control/Respawn
@onready var full_screen_text: RichTextLabel = $FullScreenText

@export var node_indicator_scene: PackedScene

@export var camera: Camera2D

var playing_level: bool = false

signal exit_level
signal respawn


func _ready() -> void:
	Helpers.levels_ui = self
	reset()

func _process(delta: float) -> void:
	pass


func reset() -> void:
	resume()
	destroy_all_indicators()

func pause() -> void:
	if respawn_menu.visible: return
	pause_menu.visible = true
	resume_btn.grab_focus()
	get_tree().paused = true

func resume() -> void:
	if respawn_menu.visible: return
	pause_menu.visible = false
	get_tree().paused = false

func open_respawn_menu(text: String) -> void:
	get_tree().paused = true
	respawn_menu.visible = true
	respawn_btn.grab_focus()
	$RespawnMenu/RichTextLabel.text = text

func _on_exit_level_pressed() -> void:
	respawn_menu.visible = false
	exit_level.emit()
	resume()

func _on_respawn_pressed() -> void:
	respawn_menu.visible = false
	respawn.emit()
	resume()

func create_node_indicator(target: Node2D) -> NodeIndicator:
	var node_indicator: NodeIndicator = node_indicator_scene.instantiate()
	node_indicator.target = target
	node_indicator.origin_point = camera
	add_child(node_indicator)
	return node_indicator

func destroy_all_indicators() -> void:
	for indicator: NodeIndicator in get_children().filter(func (child: Node) -> bool: return child is NodeIndicator):
		print(indicator)
		if indicator: indicator.destroy.call_deferred()
