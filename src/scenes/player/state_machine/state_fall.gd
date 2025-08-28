extends State
class_name StateFall


func process(delta: float) -> State:
	if player.is_on_floor():
		return state_machine.walk
	elif not state_machine.disable_climb and (state_machine.raycast_left.get_collider() is TileMapLayer or state_machine.raycast_right.get_collider() is TileMapLayer):
		return state_machine.climb
	var direction: float = Input.get_axis("move_left", "move_right")
	if state_machine.on_floor_buffer > 0:
		if state_machine.jump_buffer > 0 && player.velocity.y >= 0:
			player.velocity.y = player.JUMP_VELOCITY
		if direction: player.velocity.x = direction * player.SPEED
		else: player.velocity.x = move_toward(player.velocity.x, 0, 6000 * delta)
	else:
		if direction: player.velocity.x = move_toward(player.velocity.x, direction * player.SPEED, 900 * delta)
		else: player.velocity.x = move_toward(player.velocity.x, 0, 300 * delta)
	
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= 0.25
	
	player.apply_gravity(delta, 2 if player.velocity.y > 0 else 1)
	player.move_and_slide()
	return null
