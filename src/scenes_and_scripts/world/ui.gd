extends Control
class_name UI


@onready var pause_menu: Panel = $PauseMenu
@onready var respawn_menu: Panel = $RespawnMenu

signal exit_level
signal respawn


func _ready() -> void:
	resume()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()


func pause() -> void:
	pause_menu.visible = true
	get_tree().paused = true

func resume() -> void:
	pause_menu.visible = false
	get_tree().paused = false

func open_respawn_menu(text: String) -> void:
	get_tree().paused = true
	respawn_menu.visible = true
	$RespawnMenu/RichTextLabel.text = text

func _on_exit_level_pressed() -> void:
	resume()
	exit_level.emit()
	respawn_menu.visible = false

func _on_respawn_pressed() -> void:
	get_tree().paused = false
	respawn.emit()
	respawn_menu.visible = false
