extends Control
class_name UI


@export var pause_menu: Control


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

func exit_level() -> void:
	resume()
	get_tree().change_scene_to_file("res://scenes_and_scripts/world/level_selection/level_selection.tscn")
