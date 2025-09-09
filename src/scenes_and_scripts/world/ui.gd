extends Control
class_name UI


@export var pause_menu: Control

signal exit_level


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

func exit_level_pressed() -> void:
	resume()
	exit_level.emit()
