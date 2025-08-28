extends State
class_name StateClimb


func process(delta: float) -> State:
	if player.is_on_floor():
		return state_machine.walk
	var left: bool = state_machine.raycast_left.get_collider() is TileMapLayer
	var right: bool = state_machine.raycast_right.get_collider() is TileMapLayer
	if not left and not right:
		return state_machine.fall
	var dir: int = -1 if left else (1 if right else 0)
	if Input.is_action_just_pressed("jump"):
		player.velocity.x = -dir * player.SPEED
		player.velocity.y = player.JUMP_VELOCITY
		player.move_and_slide()
		state_machine.disable_climb = true
		return state_machine.fall
	if Input.is_action_just_pressed("move_left" if right else "move_right"):
		state_machine.on_floor_buffer = state_machine.MAX_ON_FLOOR_BUFFER
		state_machine.disable_climb = true
		return state_machine.fall
	player.velocity.y = player.CLIMB_DOWN_VELOCITY
	player.move_and_slide()
	return null
