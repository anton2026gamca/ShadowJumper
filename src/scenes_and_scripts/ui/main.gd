extends Control
class_name Main


@export var level_selection_layer: CanvasLayer
@export var ui_layer: CanvasLayer
@export var main_menu: Menu


func _ready() -> void:
	Helpers.main_menu = self
	pause()


func play() -> void:
	level_selection_layer.process_mode = Node.PROCESS_MODE_PAUSABLE
	ui_layer.process_mode = Node.PROCESS_MODE_DISABLED

func pause() -> void:
	main_menu.open()
	level_selection_layer.process_mode = Node.PROCESS_MODE_DISABLED
	ui_layer.process_mode = Node.PROCESS_MODE_PAUSABLE


func _on_main_menu_closed() -> void:
	play()
