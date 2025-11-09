extends Node2D
class_name Main


@export var level_selection_layer: CanvasLayer
@export var ui_layer: CanvasLayer
@export var main_menu: MainMenu

@onready var level_selection: LevelSelection = $LevelSelection/LevelSelection/SubViewport/LevelSelection
@onready var level_selection_ui_nodes: Node2D = $LevelSelection/LevelSelectionUINodes


func _ready() -> void:
	Helpers.main_menu = self
	pause(true)
	await get_tree().process_frame
	level_selection_ui_nodes.scale = Vector2(1, 1)
	for node: Control in level_selection.ui_nodes:
		node.reparent(level_selection_ui_nodes)
	for level: LevelSelectionLevel in level_selection.levels:
		level.label.reparent(level_selection_ui_nodes)
	level_selection_ui_nodes.scale = Vector2(3, 3)
	if OS.has_feature("raspberrypi"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		var new_mode: DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_FULLSCREEN
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			new_mode = DisplayServer.WINDOW_MODE_WINDOWED
		DisplayServer.window_set_mode(new_mode)
	_update_level_ui_nodes_postition.call_deferred()

func _update_level_ui_nodes_postition() -> void:
	level_selection_ui_nodes.position = (get_viewport_rect().size * 0.5) - (level_selection.camera.get_screen_center_position() * 3)


func play() -> void:
	level_selection_layer.process_mode = Node.PROCESS_MODE_PAUSABLE
	ui_layer.process_mode = Node.PROCESS_MODE_DISABLED

func pause(instant: bool = false) -> void:
	main_menu.open(instant)
	level_selection_layer.process_mode = Node.PROCESS_MODE_DISABLED
	ui_layer.process_mode = Node.PROCESS_MODE_PAUSABLE


func _on_main_menu_closed() -> void:
	play()


func _on_level_selection_entered_level() -> void:
	level_selection_ui_nodes.visible = false

func _on_level_selection_exited_level() -> void:
	level_selection_ui_nodes.visible = true
