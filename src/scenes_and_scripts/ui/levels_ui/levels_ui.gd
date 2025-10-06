extends Control
class_name LevelsUI

@onready var pause_menu: PauseMenu = $PauseMenu
@onready var respawn_menu: RespawnMenu = $RespawnMenu
@onready var full_screen_text: RichTextLabel = $FullScreenText
@onready var dialog_ui: DialogUI = $DialogUI
@onready var energy_display: PanelContainer = $EnergyDisplay
@onready var energy_label: Label = $EnergyDisplay/Label

@export var node_indicator_scene: PackedScene

@export var camera: Camera2D

var playing_level: bool = false

signal exit_level
signal respawn


func _ready() -> void:
	Settings.collected_energy_changed.connect(_on_collected_energy_changed)
	Helpers.levels_ui = self
	reset()

func _process(_delta: float) -> void:
	pass


func reset() -> void:
	resume()
	destroy_all_indicators()
	_on_collected_energy_changed()
	energy_display.visible = true

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
	energy_display.visible = false
	respawn_menu.open_with_message(text)

func _on_exit_level_pressed() -> void:
	respawn_menu.close()
	resume()
	exit_level.emit()

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
	energy_label.text = str(int(Settings.total_collected_energy)) + " E"
	var color: Color = Color.WHITE
	if Settings.total_collected_energy >= 400: color = Color.LIME
	elif Settings.total_collected_energy >= 200: color = Color.YELLOW
	elif Settings.total_collected_energy >= 100: color = Color.LIGHT_BLUE
	elif Settings.total_collected_energy < 0: color = Color.RED
	energy_label.add_theme_color_override("font_color", color)
