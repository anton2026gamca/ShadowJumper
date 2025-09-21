extends Control
class_name MainMenu


@export var default_focus: Control
@onready var level_selection: CanvasLayer = $LevelSelection
@onready var menu: CanvasLayer = $Menu
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	Helpers.main_menu = self
	default_focus.grab_focus()
	pause()


func play() -> void:
	animation_player.play_backwards("menu_open")
	await animation_player.animation_finished
	level_selection.process_mode = Node.PROCESS_MODE_PAUSABLE
	menu.process_mode = Node.PROCESS_MODE_DISABLED

func pause() -> void:
	animation_player.play("menu_open")
	default_focus.grab_focus()
	level_selection.process_mode = Node.PROCESS_MODE_DISABLED
	menu.process_mode = Node.PROCESS_MODE_PAUSABLE


func _on_play_pressed() -> void:
	play()

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	pass # Replace with function body.
