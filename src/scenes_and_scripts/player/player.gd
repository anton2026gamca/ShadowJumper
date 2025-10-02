@tool
extends CharacterBody2D
class_name Player


@onready var death_audio: AudioStreamPlayer2D = $DeathAudio

var enable_in_editor: bool = false
var controller: PlayerController

@export var lives: int = 1
signal died(reason: String)
signal took_damage(reason: String)


func _ready() -> void:
	enable_in_editor = false

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint() and not enable_in_editor:
		return
	move_and_slide()

func _on_death_component_die(reason: String) -> void:
	lives -= 1
	took_damage.emit(reason)
	death_audio.pitch_scale = randf() * 0.2 + 0.9
	death_audio.play()
	if lives <= 0:
		died.emit(reason)
