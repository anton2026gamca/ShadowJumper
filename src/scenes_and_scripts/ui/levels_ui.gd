extends Control
class_name LevelsUI

@onready var pause_menu: Panel = $PauseMenu
@onready var resume_btn: Button = $PauseMenu/VBoxContainer/Control/Resume
@onready var respawn_menu: Panel = $RespawnMenu
@onready var respawn_btn: Button = $RespawnMenu/Control/Respawn
@onready var full_screen_text: RichTextLabel = $FullScreenText

var playing_level: bool = false

signal exit_level
signal respawn


func _ready() -> void:
	resume()

func _process(delta: float) -> void:
	pass


func pause() -> void:
	pause_menu.visible = true
	resume_btn.grab_focus()
	get_tree().paused = true

func resume() -> void:
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
