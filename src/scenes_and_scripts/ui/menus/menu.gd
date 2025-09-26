@tool
extends Control
class_name Menu


@export_tool_button("Open") var open_btn: Callable = open
@export_tool_button("Close") var close_btn: Callable = close.bind(true)

@export var default_focus: Control
@export var animation_speed_scale: float = 1.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal animation_finished
signal starting_close
signal closed

var is_open: bool = false


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)


func open(instant: bool = false) -> void:
	if is_open: return
	is_open = true
	visible = true
	animation_player.play("menu_open", -1, animation_speed_scale, instant)
	default_focus.grab_focus()

func close(internal: bool = false) -> void:
	if not is_open: return
	print("Closing menu ", name)
	is_open = false
	animation_player.play("menu_open", -1, -animation_speed_scale, true)
	if not internal:
		starting_close.emit()
	await animation_player.animation_finished
	visible = false
	if not internal:
		closed.emit()

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	animation_finished.emit()

func open_sub_menu(menu: Menu) -> void:
	close(true)
	menu.open()
	await menu.starting_close
	open()
