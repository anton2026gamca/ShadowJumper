extends Node
class_name Main


@export var level_selection_layer: CanvasLayer
@export var ui_layer: CanvasLayer
@export var main_menu: MainMenu


func _ready() -> void:
	Helpers.main_menu = self
	pause(true)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		var new_mode: DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_FULLSCREEN
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			new_mode = DisplayServer.WINDOW_MODE_WINDOWED
		DisplayServer.window_set_mode(new_mode)


func play() -> void:
	level_selection_layer.process_mode = Node.PROCESS_MODE_PAUSABLE
	ui_layer.process_mode = Node.PROCESS_MODE_DISABLED

func pause(instant: bool = false) -> void:
	main_menu.open(instant)
	level_selection_layer.process_mode = Node.PROCESS_MODE_DISABLED
	ui_layer.process_mode = Node.PROCESS_MODE_PAUSABLE


func _on_main_menu_closed() -> void:
	play()
