extends PlayerController
class_name UserPlayerController



func get_move_left() -> bool:
	return Input.is_action_pressed("move_left")

func get_move_right() -> bool:
	return Input.is_action_pressed("move_right")

func get_move_dir() -> float:
	return Input.get_axis("move_left", "move_right")

func get_jump() -> bool:
	return Input.is_action_just_pressed("jump") and not disable_jump

func get_jump_released() -> bool:
	return Input.is_action_just_released("jump")

func get_dash() -> bool:
	return Input.is_action_pressed("dash")

func get_throw_a_rock() -> bool:
	return Input.is_action_just_pressed("throw_a_rock")

func get_climb_ladder_up() -> bool:
	return Input.is_action_pressed("climb_or_swim_up")

func get_climb_ladder_down() -> bool:
	return Input.is_action_pressed("climb_or_swim_down")

func get_climb_ladder_dir() -> int:
	return Input.get_axis("climb_or_swim_up", "climb_or_swim_down")
