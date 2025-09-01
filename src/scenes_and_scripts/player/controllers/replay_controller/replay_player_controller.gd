@tool
extends PlayerController
class_name ReplayPlayerController


func _ready() -> void:
	if Engine.is_editor_hint():
		InputMap.load_from_project_settings()

func _process(delta: float) -> void:
	pass
