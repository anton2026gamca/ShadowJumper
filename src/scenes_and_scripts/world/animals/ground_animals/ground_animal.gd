extends Animal
class_name GroundAnimal


@export var player_die_reason: String

@export_group("Behaviour")
@export var walk_speed: float
@export var run_speed: float
@export_group("Behaviour/Searching")
@export var chance_to_rotate: float = 0.005
@export var rotate_down_time: float = 2.0
@export_group("Behaviour/Attacking")
@export var chance_to_give_up: float = 0.003
@export var give_up_time: float = 3.0


func _physics_process(delta: float) -> void:
	move_and_slide()

func get_player_die_reason() -> String:
	return player_die_reason

func get_walk_speed() -> float:
	return walk_speed

func get_run_speed() -> float:
	return run_speed
