extends Node
class_name PlayerController


@export var target: Player

@export_group("Movement")
@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var max_fall_velocity: float = 750.0
@export var dash_velocity: float = 2000.0
@export var climb_down_velocity: float = 50.0
## In milliseconds
@export var jump_buffer_time: float = 80.0
## In milliseconds
@export var coyote_time: float = 100.0
@export var ladder_climb_speed: float = 100.0
@export var water_max_speed: float = 100.0
@export var water_acceleration: float = 100.0

var last_on_floor_time: float = -1000
var last_jump_time: float = -1000

var disable_jump: bool = false
var disable_climb: bool = false

@export_group("Rock throwing")
@export var rock_scene: PackedScene
@export var rock_travel_speed: float = 500.0
@export var max_throw_dist: float = 16 * 14

@export_group("Hit and Death")
@export var immunity_time: float = 2.0

@export_group("Physics")
@export var climb_left_raycast: RayCast2D
@export var climb_right_raycast: RayCast2D
@export var climb_ladder_area: Area2D
@export var in_water_area: Area2D

@export_group("SFX")
@export var jump_audio: AudioStreamPlayer2D
@export var dash_audio: AudioStreamPlayer2D
@export var fall_audio: AudioStreamPlayer2D
@export var in_water_audio: AudioStreamPlayer2D

@export_group("Effects")
@export var jump_particles: CPUParticles2D
@export var land_particles: CPUParticles2D
@export var climb_particles: CPUParticles2D

var in_light_time: float = 0


func _ready() -> void:
	target.controller = self

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

func get_throw_a_rock() -> bool:
	return false

func is_on_floor() -> bool:
	return target.is_on_floor()

func is_on_floor_buffered() -> bool:
	return last_on_floor_time > -coyote_time

func get_climb_ladder_up() -> bool:
	return false

func get_climb_ladder_down() -> bool:
	return false

func get_climb_ladder_dir() -> int:
	return 0

func is_in_water() -> bool:
	return not in_water_area.get_overlapping_areas().is_empty()


func get_nearest_mushroom() -> Mushroom:
	var all: Array[Node] = get_tree().get_nodes_in_group("Mushrooms")
	var nearest_dist: float = INF
	var nearest: Mushroom = null
	for mushroom: Node in all:
		if not mushroom is Mushroom:
			continue
		var dist: float = target.global_position.distance_squared_to(mushroom.global_position)
		if dist < nearest_dist and dist <= (max_throw_dist * max_throw_dist) and mushroom.is_on:
			nearest_dist = dist
			nearest = mushroom
	return nearest

func throw_a_rock() -> void:
	if Progress.total_rocks <= 0: return
	var nearest_mushroom: Mushroom = get_nearest_mushroom()
	if nearest_mushroom:
		var rock: Rock = rock_scene.instantiate()
		target.get_parent().add_child(rock)
		rock.global_position = target.global_position
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(rock, "global_position", nearest_mushroom.global_position, target.global_position.distance_to(nearest_mushroom.global_position) / rock_travel_speed)
		Progress.collect_rocks(-1)
		
		await tween.finished
		
		rock.destroy()
		if nearest_mushroom:
			nearest_mushroom.hit()

func jump() -> void:
	target.velocity.y = jump_velocity
	disable_jump = true
	if jump_audio:
		jump_audio.pitch_scale = randf_range(0.75, 1.25)
		jump_audio.play()
	if jump_particles: jump_particles.restart()

@warning_ignore("shadowed_variable_base_class")
func apply_gravity(delta: float, scale: float = 1.0) -> void:
	var g = target.get_gravity()
	if Engine.is_editor_hint():
		g = ProjectSettings.get_setting("physics/2d/default_gravity") as float * ProjectSettings.get_setting("physics/2d/default_gravity_vector") as Vector2
	target.velocity += g * delta * scale
	target.velocity.y = min(target.velocity.y, max_fall_velocity)
