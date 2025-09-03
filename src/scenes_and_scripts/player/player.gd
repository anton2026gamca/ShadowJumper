@tool
extends CharacterBody2D
class_name Player


var enable_in_editor: bool = false


func _ready() -> void:
	enable_in_editor = false
	if Engine.is_editor_hint():
		return

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint() and not enable_in_editor:
		return
	move_and_slide()
