@tool
extends State
class_name PlayerInWater


@export var controller: PlayerController


func process(delta: float) -> Variant:
	if controller.get_throw_a_rock():
		controller.throw_a_rock()
	if not controller.is_in_water():
		return PlayerFall
	if controller.is_on_floor() and controller.get_jump_buffered():
		controller.jump()
		controller.target.velocity.y *= 0.25
		controller.disable_jump = false
	var target_v: Vector2 = Input.get_vector("move_left", "move_right", "climb_or_swim_up", "climb_or_swim_down").normalized() * controller.water_max_speed
	if target_v.x == 0: controller.target.velocity.x = move_toward(controller.target.velocity.x, 0, controller.target.velocity.x * controller.target.velocity.x * 0.05 * delta)
	else: controller.target.velocity.x = move_toward(controller.target.velocity.x, target_v.x, controller.water_acceleration * delta)
	if target_v.y == 0: controller.target.velocity.y = move_toward(controller.target.velocity.y - 20, 0, (controller.target.velocity.y - 20) * (controller.target.velocity.y - 20) * 0.05 * delta) + 20
	else: controller.target.velocity.y = move_toward(controller.target.velocity.y, target_v.y, controller.water_acceleration * delta)
	return null
