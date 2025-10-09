extends Control
class_name Main


@export var level_selection_layer: CanvasLayer
@export var ui_layer: CanvasLayer
@export var main_menu: MainMenu


func _ready() -> void:
	Helpers.main_menu = self
	pause(true)


func play() -> void:
	level_selection_layer.process_mode = Node.PROCESS_MODE_PAUSABLE
	ui_layer.process_mode = Node.PROCESS_MODE_DISABLED

func pause(instant: bool = false) -> void:
	main_menu.open(instant)
	level_selection_layer.process_mode = Node.PROCESS_MODE_DISABLED
	ui_layer.process_mode = Node.PROCESS_MODE_PAUSABLE


func _process(delta: float) -> void:
	print(Settings.total_collected_energy)

func _on_main_menu_closed() -> void:
	play()
