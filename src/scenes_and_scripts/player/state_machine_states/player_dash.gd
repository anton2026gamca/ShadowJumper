@tool
extends State
class_name PlayerDash


@export var controller: PlayerController


func process(delta: float) -> String:
	if abs(controller.target.velocity.x) == 0:
		return "PlayerFall"
	if abs(controller.target.velocity.x) < 100:
		controller.target.velocity.x = move_toward(controller.target.velocity.x, 0, 300 * delta)
		controller.apply_gravity(delta)
	else:
		controller.target.velocity.x = move_toward(controller.target.velocity.x, 0, 8000 * delta)
	if controller.get_jump_buffered():
		controller.target.velocity.x = min(max(controller.target.velocity.x, -controller.speed), controller.speed)
		controller.target.velocity.y = controller.jump_velocity
		controller.disable_jump = true
		controller.play_sfx(controller.sfx_jump)
		return "PlayerFall"
	return ""
