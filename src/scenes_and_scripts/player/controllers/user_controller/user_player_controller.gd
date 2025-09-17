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

func get_climb_lader_up() -> bool:
	return Input.is_action_pressed("lader_climb_up")

func get_climb_lader_down() -> bool:
	return Input.is_action_pressed("lader_climb_down")

func get_climb_lader_dir() -> int:
	return Input.get_axis("lader_climb_up", "lader_climb_down")
