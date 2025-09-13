extends CharacterBody2D
class_name Animal


func _physics_process(delta: float) -> void:
	move_and_slide()

func get_player_die_reason() -> String:
	return "An animal killed you!"

func get_walk_speed() -> float:
	return 600.0

func get_run_speed() -> float:
	return 3000.0
