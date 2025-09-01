extends State
class_name PlayerClimb


@export var controller: PlayerController


func process(_delta: float) -> String:
	if controller.is_on_floor():
		return "PlayerWalk"
	var left: bool = controller.climb_left_raycast.get_collider() is TileMapLayer
	var right: bool = controller.climb_right_raycast.get_collider() is TileMapLayer
	if not left and not right:
		return "PlayerFall"
	var dir: int = -1 if left else (1 if right else 0)
	if controller.get_jump_buffered():
		controller.target.velocity.x = -dir * controller.speed
		controller.target.velocity.y = controller.jump_velocity
		controller.play_sfx(controller.sfx_jump)
		controller.disable_jump = true
		controller.disable_climb = true
		return "PlayerFall"
	if (controller.get_move_left() if right else controller.get_move_right()):
		controller.last_on_floor_time = 0
		controller.disable_climb = true
		return "PlayerFall"
	controller.target.velocity.y = controller.climb_down_velocity
	return ""
