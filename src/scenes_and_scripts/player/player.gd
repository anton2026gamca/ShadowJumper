@tool
extends CharacterBody2D
class_name Player


var enable_in_editor: bool = false

var light_sources: Array[Node2D]

signal died(reason: String)


func _ready() -> void:
	enable_in_editor = false
	if Engine.is_editor_hint():
		return

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint() and not enable_in_editor:
		return
	move_and_slide()


func die(reason: String) -> void:
	died.emit(reason)

func _on_light_area_body_entered(body: Node2D) -> void:
	light_sources.append(body)

func _on_light_area_body_exited(body: Node2D) -> void:
	light_sources.remove_at(light_sources.find(body))
