extends Node
class_name PlayerController


@export var target: Player

@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var max_fall_velocity: float = 750.0
@export var dash_velocity: float = 2000.0
@export var climb_down_velocity: float = 50.0
## In milliseconds
@export var jump_buffer_time: float = 80.0
## In milliseconds
@export var coyote_time: float = 100.0

var last_on_floor_time: float = 0
var last_jump_time: float = 0

var disable_jump: bool = false
var disable_climb: bool = false

@export_group("Physics")
@export var climb_left_raycast: RayCast2D
@export var climb_right_raycast: RayCast2D

@export_group("SFX")
@export var enable_sfx: bool = true
@export var sfx_jump: AudioStream
@export var sfx_dash: AudioStream


func _process(delta: float) -> void:
	last_on_floor_time -= delta * 1000
	if is_on_floor():
		last_on_floor_time = 0
	last_jump_time -= delta * 1000
	if get_jump():
		last_jump_time = 0

func get_move_left() -> bool:
	return false

func get_move_right() -> bool:
	return false

func get_move_dir() -> float:
	return 0

func get_jump() -> bool:
	return false

func get_jump_released() -> bool:
	return false

func get_jump_buffered() -> bool:
	return last_jump_time > -jump_buffer_time and not disable_jump

func get_dash() -> bool:
	return false

func is_on_floor() -> bool:
	return target.is_on_floor()

func is_on_floor_buffered() -> bool:
	return last_on_floor_time > -coyote_time


@warning_ignore("shadowed_variable_base_class")
func apply_gravity(delta: float, scale: float = 1.0) -> void:
	target.velocity += target.get_gravity() * delta * scale
	target.velocity.y = min(target.velocity.y, max_fall_velocity)

func play_sfx(sfx: AudioStream) -> void:
	if not enable_sfx:
		return
	var pl: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	pl.stream = sfx
	pl.autoplay = true
	pl.pitch_scale = (randf() / 8.0) + (1.0 - (1.0 / 8.0) / 2.0)
	target.add_child(pl)
	await pl.finished
	target.remove_child(pl)
