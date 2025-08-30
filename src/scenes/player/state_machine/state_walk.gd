extends State
class_name StateWalk


func process(delta: float) -> State:
	if state_machine.jump_buffer > 0:
		player.velocity.y = player.JUMP_VELOCITY
		state_machine.jump_buffer = 0
		state_machine.play_sfx(state_machine.sfx_jump)
	
	var direction: float = Input.get_axis("move_left", "move_right")
	if direction: player.velocity.x = direction * player.SPEED
	else: player.velocity.x = move_toward(player.velocity.x, 0, 100)
	
	player.move_and_slide()
	
	if state_machine.on_floor_buffer > 0 && Input.is_action_just_pressed("dash") && direction:
		player.velocity = Vector2(direction * player.DASH_VELOCITY, 0)
		state_machine.play_sfx(state_machine.sfx_dash)
		return state_machine.dash
	if not player.is_on_floor():
		return state_machine.fall
	return null
