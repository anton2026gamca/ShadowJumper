extends State
class_name StateDash


func process(delta: float) -> State:
	if abs(player.velocity.x) == 0:
		return state_machine.fall
	if abs(player.velocity.x) < 100:
		player.velocity.x = move_toward(player.velocity.x, 0, 300 * delta)
		player.apply_gravity(delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, 8000 * delta)
	player.move_and_slide()
	if state_machine.jump_buffer > 0:
		player.velocity.y = player.JUMP_VELOCITY
		return state_machine.fall
	return null
