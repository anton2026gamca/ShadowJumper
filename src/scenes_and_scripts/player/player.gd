@tool
extends CharacterBody2D
class_name Player


var enable_in_editor: bool = false

signal died(reason: String)

@export var controller: PlayerController


func _ready() -> void:
	enable_in_editor = false

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint() and not enable_in_editor:
		return
	move_and_slide()

func _on_death_component_die(reason: String) -> void:
	$DeathAudio.pitch_scale = randf() * 0.2 + 0.9
	$DeathAudio.play()
	died.emit(reason)
