extends State
class_name PlayerFall


@export var controller: PlayerController


func process(delta: float) -> String:
	if controller.is_on_floor():
		controller.disable_jump = false
		return "PlayerWalk"
	elif not controller.climb_left_raycast.get_collider() is TileMapLayer and not controller.climb_right_raycast.get_collider() is TileMapLayer:
		controller.disable_climb = false
	elif not controller.disable_climb:
		controller.disable_jump = false
		return "PlayerClimb"
	var direction: float = controller.get_move_dir()
	if controller.is_on_floor_buffered():
		if controller.get_jump_buffered():
			controller.target.velocity.y = controller.jump_velocity
			controller.disable_jump = true
			controller.play_sfx(controller.sfx_jump)
		if direction: controller.target.velocity.x = direction * controller.speed
		else: controller.target.velocity.x = move_toward(controller.target.velocity.x, 0, 6000 * delta)
	else:
		if direction: controller.target.velocity.x = move_toward(controller.target.velocity.x, direction * controller.speed, 900 * delta)
		else: controller.target.velocity.x = move_toward(controller.target.velocity.x, 0, 300 * delta)
	
	if controller.get_jump_released() and controller.target.velocity.y < 0:
		controller.target.velocity.y *= 0.25
	
	controller.apply_gravity(delta, 2 if controller.target.velocity.y > 0 else 1)
	return ""
