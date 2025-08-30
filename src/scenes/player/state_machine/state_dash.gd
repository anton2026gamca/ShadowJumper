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
		player.velocity.x = min(max(player.velocity.x, -player.SPEED), player.SPEED)
		state_machine.jump_buffer = 0
		state_machine.on_floor_buffer = 0
		state_machine.play_sfx(state_machine.sfx_jump)
		return state_machine.fall
	return null
