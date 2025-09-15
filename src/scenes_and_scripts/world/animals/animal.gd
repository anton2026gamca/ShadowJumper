extends CharacterBody2D
class_name Animal


@export var player_die_reason: String

@export var walk_speed: float
@export var run_speed: float


func _physics_process(delta: float) -> void:
	move_and_slide()

func get_player_die_reason() -> String:
	return player_die_reason

func get_walk_speed() -> float:
	return walk_speed

func get_run_speed() -> float:
	return run_speed
