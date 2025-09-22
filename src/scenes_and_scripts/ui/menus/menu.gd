extends Control
class_name Menu


@export var default_focus: Control
@export var animation_player: AnimationPlayer

signal animation_finished
signal closed


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)


func open() -> void:
	visible = true
	animation_player.play("menu_open")
	default_focus.grab_focus()

func close(internal: bool = false) -> void:
	animation_player.play_backwards("menu_open")
	await animation_finished
	if not internal:
		closed.emit()
	visible = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_finished.emit()
