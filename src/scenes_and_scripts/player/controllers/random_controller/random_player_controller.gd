extends PlayerController
class_name RandomPlayerController


func get_move_dir() -> float:
	return randi_range(-1, 1)

func get_jump() -> bool:
	return randi_range(1, 100) > 99

func get_dash() -> bool:
	return randi_range(1, 100) > 98
