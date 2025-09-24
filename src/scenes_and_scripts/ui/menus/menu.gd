extends Control
class_name Menu


@export var default_focus: Control
@export var animation_speed_scale: float = 1.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal animation_finished
signal starting_close
signal closed

var is_open: bool = false


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)


func open() -> void:
	if is_open: return
	is_open = true
	visible = true
	animation_player.play("menu_open", -1, animation_speed_scale)
	default_focus.grab_focus()

func close(internal: bool = false) -> void:
	if not is_open: return
	is_open = false
	animation_player.play("menu_open", -1, -animation_speed_scale, true)
	if not internal:
		starting_close.emit()
	await animation_player.animation_finished
	visible = false
	if not internal:
		closed.emit()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_finished.emit()

func open_sub_menu(menu: Menu) -> void:
	close(true)
	menu.open()
	await menu.starting_close
	open()
