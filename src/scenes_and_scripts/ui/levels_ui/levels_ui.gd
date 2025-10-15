extends Control
class_name LevelsUI

@onready var pause_menu: PauseMenu = $PauseMenu
@onready var respawn_menu: RespawnMenu = $RespawnMenu
@onready var full_screen_text: RichTextLabel = $FullScreenText
@onready var dialog_ui: DialogUI = $DialogUI
@onready var top_bar: PanelContainer = $TopBar
@onready var energy_label: Label = $TopBar/HBoxContainer/EnergyDisplay/EnergyText
@onready var rocks_label: Label = $TopBar/HBoxContainer/RocksDisplay/RocksText

@export var node_indicator_scene: PackedScene

@export var camera: Camera2D

var playing_level: bool = false

signal exit_level(args: Array)
signal respawn


func _ready() -> void:
	Progress.collected_energy_changed.connect(_on_collected_energy_changed)
	Progress.rocks_changed.connect(_on_rocks_changed)
	Helpers.levels_ui = self
	reset()

func _process(_delta: float) -> void:
	pass


func reset() -> void:
	resume()
	destroy_all_indicators()
	_on_collected_energy_changed()
	_on_rocks_changed()
	top_bar.visible = true

func pause() -> void:
	if get_tree().paused: return
	pause_menu.open()
	get_tree().paused = true

func resume() -> void:
	if not get_tree().paused or respawn_menu.is_open: return
	await pause_menu.close()
	get_tree().paused = false

func open_respawn_menu(text: String) -> void:
	get_tree().paused = true
	top_bar.visible = false
	respawn_menu.open_with_message(text)

func _on_exit_level_pressed() -> void:
	if respawn_menu.is_open:
		respawn_menu.close()
		exit_level.emit([false, false])
	else:
		exit_level.emit([false, true])
	resume()

func _on_respawn_menu_respawn() -> void:
	if not respawn_menu.is_open: return
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

func _on_collected_energy_changed() -> void:
	energy_label.text = str(int(Progress.total_collected_energy)) + " E"
	energy_label.add_theme_color_override("font_color", Helpers.get_energy_level_color(Progress.total_collected_energy))

func _on_rocks_changed() -> void:
	rocks_label.text = str(int(Progress.total_rocks)) + " R"
	var color: Color = Color.LIME
	if Progress.total_rocks < 5: color = Color.RED
	elif Progress.total_rocks < 10: color = Color.ORANGE
	elif Progress.total_rocks < 20: color = Color.YELLOW
	rocks_label.add_theme_color_override("font_color", color)
